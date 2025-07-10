from A2_user_utils import logger, validate_required_fields, CLIENT_ID, cognito_client

required_fields = {"email": str, "new_password": str, "code": str}


def confirm_forgot_pass(user):
    logger.info(user)
    email, code, new_pass = validate_confirm_forgot_password(user)
    cognito_client.confirm_forgot_password(
            ClientId=CLIENT_ID,
            Username=email,
            ConfirmationCode=code,
            Password=new_pass
        )
    return "Password reset successful"


def validate_confirm_forgot_password(data):
    # Validate required fields exist
    validate_required_fields(data, required_fields)
    
    # email and pass
    username = data["email"].lower()
    code = data["code"]
    password = data["new_password"]
    return  username, code, password