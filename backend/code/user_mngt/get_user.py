from A2_user_utils import logger, get_user_id_from_token, validate_required_fields, get_user_from_table
required_fields = {"auth": str}


def get_user_info(user):
    logger.info(user)
    validate_get_user(user)
    user_check = get_user_id_from_token(user["auth"])
    if not user_check:
        raise ValueError("Invalid credentials")
    if "user_id" in user:
        user_id = user["user_id"]
    else:
        user_id = user_check
    user_info = get_user_from_table(user_id)
    return user_info


# if user id is in the request, it means a user is trying to get another user's info
# if not, it means the user is trying to get their own info
def validate_get_user(data):
    validate_required_fields(data, required_fields)
    if "user_id" in data:
        user_id = data["user_id"]
        if not isinstance(user_id, str):
            raise ValueError("user_id must be a string")
        if not user_id.startswith("user_"):
            raise ValueError("user_id must start with 'user_'")