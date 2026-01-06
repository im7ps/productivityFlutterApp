from datetime import datetime, timezone

# Utility function to get current UTC time
def get_utc_now():
    return datetime.now(timezone.utc)
