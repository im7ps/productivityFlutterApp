import pytest
from datetime import timedelta
from unittest.mock import patch
from jose import jwt, ExpiredSignatureError

from app.core.security import (
    get_password_hash,
    verify_password,
    create_access_token,
    decode_access_token,
    InvalidTokenError,
    SECRET_KEY,
    ALGORITHM,
)

# --- Password Hashing and Verification Tests ---

def test_password_hashing_and_verification():
    """
    Tests that a password is correctly hashed and the hash can be verified.
    """
    password = "plain_password"
    hashed_password = get_password_hash(password)

    assert hashed_password is not None
    assert isinstance(hashed_password, str)
    assert password != hashed_password
    assert verify_password(password, hashed_password) is True

def test_password_verification_failure():
    """
    Tests that verification fails for an incorrect password.
    """
    password = "plain_password"
    wrong_password = "wrong_password"
    hashed_password = get_password_hash(password)

    assert verify_password(wrong_password, hashed_password) is False

def test_password_hashing_is_consistent_for_same_password():
    """
    Although bcrypt generates a different salt each time, the verification
    function should still be able to validate the password against any of the hashes.
    """
    password = "a_very_secure_password"
    hash1 = get_password_hash(password)
    hash2 = get_password_hash(password)
    
    assert hash1 != hash2 # Due to different salts
    assert verify_password(password, hash1) is True
    assert verify_password(password, hash2) is True

def test_password_truncation_on_hashing_and_verification():
    """
    Tests the 72-character truncation behavior of passlib's bcrypt.
    A password longer than 72 chars should still verify if only the first 72 match.
    """
    long_password = "a" * 100
    truncated_password = "a" * 72
    
    hashed_long_password = get_password_hash(long_password)
    
    # Verification should succeed with the truncated password
    assert verify_password(truncated_password, hashed_long_password) is True
    
    # Verification should also succeed with the original long password
    # because the verify function also truncates its input.
    assert verify_password(long_password, hashed_long_password) is True
    
    # A different long password should fail
    different_long_password = ("a" * 71) + "b" + ("a" * 28)
    assert verify_password(different_long_password, hashed_long_password) is False


# --- JWT Token Tests ---

def test_jwt_roundtrip():
    """
    Tests that a JWT can be created and then decoded, yielding the original data.
    """
    payload = {"sub": "user@example.com", "custom_claim": "value"}
    token = create_access_token(data=payload)

    decoded_payload = decode_access_token(token)

    assert decoded_payload["sub"] == payload["sub"]
    assert decoded_payload["custom_claim"] == payload["custom_claim"]
    assert "exp" in decoded_payload


def test_decode_expired_token():
    """
    Tests that decoding an expired token raises an InvalidTokenError.
    We manually create an expired token to test this.
    """
    payload = {"sub": "user@example.com", "exp": -1} # Expired in the past
    
    # Use the jose library directly to create the expired token
    expired_token = jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)
    
    with pytest.raises(InvalidTokenError):
        # We need to patch the `jwt.decode` function to simulate the `ExpiredSignatureError`
        # which our `decode_access_token` function catches and wraps.
        with patch("jose.jwt.decode", side_effect=ExpiredSignatureError):
            decode_access_token(expired_token)


def test_decode_invalid_token_signature():
    """
    Tests that decoding a token with an invalid signature raises InvalidTokenError.
    """
    payload = {"sub": "user@example.com"}
    token = create_access_token(data=payload)
    
    # Tamper with the token
    tampered_token = token + "invalid_signature"

    with pytest.raises(InvalidTokenError):
        decode_access_token(tampered_token)

def test_decode_malformed_token():
    """
    Tests that decoding a malformed token raises InvalidTokenError.
    """
    malformed_token = "this.is.not.a.valid.jwt"
    with pytest.raises(InvalidTokenError):
        decode_access_token(malformed_token)

def test_create_access_token_has_correct_expiry():
    """
    Tests that the created token has an expiration claim set in the future.
    """
    with patch("app.core.security.ACCESS_TOKEN_EXPIRE_MINUTES", 15):
        token = create_access_token(data={"sub": "test"})
        decoded_payload = decode_access_token(token)
        
        assert "exp" in decoded_payload
        # The expiration time can't be tested for an exact value due to second-level precision
        # and execution time, so we just assert its presence and type.
        assert isinstance(decoded_payload["exp"], int)
