import boto3
from A2_user_utils import logger, cognito_client, validate_required_fields, get_tokens, USER_TABLE, db, get_user_from_token

required_fields = {"password": str, "auth": str}


def delete_user_info(user):
    logger.info(user)
    validate_required_fields(user, required_fields)
    email, user_id = get_user_from_token(user["auth"])
    password = user["password"]
    #check if correct password
    user_check = get_tokens(email, password)
    if not user_check:
        raise ValueError("Invalid credentials")
    table = db.Table(USER_TABLE)
    table.delete_item(Key={'userID': user_id})
    cognito_client.delete_user(AccessToken=user["auth"])
    return "User deleted successfully"
