from datetime import datetime
from A2_user_utils import logger, cognito_client, POOL_ID, validate_required_fields, get_tokens, get_user_from_token, update_user_status

required_fields = {"password": str, "auth": str}


def disable_user_acct(user):
    logger.info(user)
    validate_required_fields(user, required_fields)
    email, user_id = get_user_from_token(user["auth"])
    password = user["password"]
    user_check = get_tokens(email, password)
    if not user_check:
        raise ValueError("Invalid credentials")
    update_user_status(user_id, "DISABLED")
    cognito_client.admin_disable_user(
        UserPoolId=POOL_ID,
        Username=email
    )
    return "User disabled successfully"
