from A2_user_utils import logger, get_tokens, validate_required_fields

required_fields = {"email": str, "password": str}


def log_in(user):
    logger.info(user)
    email, password  = validate_login(user)
    tokens = get_tokens(email, password)
    return tokens


def validate_login(data):
    # Validate required fields exist
    validate_required_fields(data, required_fields)
    # email and pass
    username = data["email"].lower()
    password = data["password"]
    return  username, password
