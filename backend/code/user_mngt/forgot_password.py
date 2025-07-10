from A2_user_utils import logger, cognito_client, CLIENT_ID, validate_required_fields, validate_email_pattern

required_fields = {"email": str}


def forgot_pass(user):
    logger.info(user)
    email = validate_forgot_password(user)
    cognito_client.forgot_password(
            ClientId=CLIENT_ID,
            Username=email
        )
    return "Code sent to your email"


def validate_forgot_password(data):
    validate_required_fields(data, required_fields)
    # email 
    email = data["email"].lower()
    validate_email_pattern(email)
    return  email