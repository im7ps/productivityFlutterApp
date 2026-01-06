class DomainException(Exception):
    """Base class for all domain-related exceptions."""
    def __init__(self, message: str):
        self.message = message
        super().__init__(self.message)


class ResourceNotFound(DomainException):
    """Raised when a requested resource is not found."""
    pass


class EntityAlreadyExists(DomainException):
    """Raised when an entity already exists in the system."""
    pass


class InvalidCredentials(DomainException):
    """Raised when provided credentials are invalid."""
    pass


class DomainValidationError(DomainException):
    """Raised when a domain validation rule is violated."""
    pass
