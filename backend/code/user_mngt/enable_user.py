from A2_user_utils import logger, cognito_client, POOL_ID, validate_required_fields, get_tokens, get_user_from_token, validate_email_pattern, update_user_status

required_fields = {"password": str, "email": str}

def enable_user_acct(user):
    logger.info(user)
    email, password = validate_enable_user(user)
    cognito_client.admin_enable_user(
        UserPoolId=POOL_ID,
        Username=email
    )
    # check credentials
    user_check = get_tokens(email, password)
    if not user_check:
        cognito_client.admin_disable_user(
            UserPoolId=POOL_ID,
            Username=email
        )
        raise ValueError("Invalid credentials")
    user_id = get_user_from_token(user_check["access_token"])[1]
    # Enable in Cognito
    cognito_client.admin_enable_user(
        UserPoolId=POOL_ID,
        Username=email
    )
    # Update status in database
    update_user_status(user_id, "ACTIVE")
    return "User enabled successfully"

def validate_enable_user(data):
    validate_required_fields(data, required_fields)
    # email and password
    email = data["email"].lower()
    password = data["password"]
    validate_email_pattern(email)
    return  email, password

