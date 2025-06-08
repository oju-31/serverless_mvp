import boto3
from auth_utils import logger
from os import getenv

client = boto3.client('cognito-idp')
CLIENT_ID = getenv("CLIENT_ID")
required_fields = {"username", "new_password", "code"}


def confirm_forgot_pass(user):
    logger.info(user)
    email, code, new_pass = validate_confirm_forgot_password(user)
    client.confirm_forgot_password(
            ClientId=CLIENT_ID,
            Username=email,
            ConfirmationCode=code,
            Password=new_pass
        )
    
    return "Password reset successful"


def validate_confirm_forgot_password(data):
    # Validate required fields exist
    for field in required_fields:
       if field not in data or not isinstance(data[field], str):
           raise ValueError(f"Missing required field '{field}', which must be a string")
    
    # email and pass
    username = data["username"].lower()
    code = data["code"]
    password = data["new_password"]
    return  username, code, password