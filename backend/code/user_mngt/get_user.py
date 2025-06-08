import boto3
from core_utils import logger
from os import getenv

client = boto3.client('cognito-idp')
CLIENT_ID = getenv("CLIENT_ID")
required_fields = {"username", "password"}


def get_user_info(user):
    logger.info(user)
    email = validate_get_user(user)
    client.forgot_password(
            ClientId=CLIENT_ID,
            Username=email
        )
    return "Code sent to your email"


def validate_get_user(data):
    # Validate required fields exist
    email = "username"
    if email not in data or not isinstance(data[email], str):
           raise ValueError(f"Missing required field '{email}', which must be a string")
    return data[email]