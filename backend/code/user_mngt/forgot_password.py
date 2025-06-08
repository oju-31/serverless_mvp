import boto3
from auth_utils import logger
from os import getenv

client = boto3.client('cognito-idp')
CLIENT_ID = getenv("CLIENT_ID")
required_fields = {"username", "password"}


def forgot_pass(user):
    logger.info(user)
    email = validate_forgot_password(user)
    client.forgot_password(
            ClientId=CLIENT_ID,
            Username=email
        )
    return "Code sent to your email"


def validate_forgot_password(data):
    # Validate required fields exist
    email = "username"
    if email not in data or not isinstance(data[email], str):
           raise ValueError(f"Missing required field '{email}', which must be a string")
    return data[email]