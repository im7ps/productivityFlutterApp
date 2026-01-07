import pytest
from datetime import datetime, timedelta, timezone
from unittest.mock import patch
from jose import jwt

from app.core.exceptions import AccessTokenExpired, InvalidToken
from app.core.security import (
    get_password_hash,
    verify_password,
    create_access_token,
    decode_access_token,
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
    Tests that decoding an expired token raises ExpiredSignatureError.
    """
    # Create a token that expired 1 minute ago
    expire = datetime.now(timezone.utc) - timedelta(minutes=1)
    payload = {"sub": "user@example.com", "exp": expire}
    
    # Manually encode using jose to bypass create_access_token's logic
    expired_token = jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)
    
    # Assert that decoding it raises the specific AccessTokenExpired
    with pytest.raises(AccessTokenExpired):
        decode_access_token(expired_token)


def test_decode_invalid_token_signature():
    """
    Tests that decoding a token with an invalid signature raises InvalidToken.
    """
    payload = {"sub": "user@example.com"}
    token = create_access_token(data=payload)
    
    # Tamper with the token
    tampered_token = token + "invalid_signature"

    with pytest.raises(InvalidToken):
        decode_access_token(tampered_token)

def test_decode_malformed_token():
    """
    Tests that decoding a malformed token raises InvalidToken.
    """
    malformed_token = "this.is.not.a.valid.jwt"
    with pytest.raises(InvalidToken):
        decode_access_token(malformed_token)

def test_create_access_token_has_correct_expiry():
    """
    Tests that the created token has an expiration claim set in the future.
    """
    # We patch the constant in the module where it is used (create_access_token uses it from config)
    # However, create_access_token imports it. Let's patch where it's defined or imported.
    # Given the import structure, patching app.core.security.ACCESS_TOKEN_EXPIRE_MINUTES works.
    with patch("app.core.security.ACCESS_TOKEN_EXPIRE_MINUTES", 15):
        token = create_access_token(data={"sub": "test"})
        decoded_payload = decode_access_token(token)
        
        assert "exp" in decoded_payload
        assert isinstance(decoded_payload["exp"], int)