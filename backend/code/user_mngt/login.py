import boto3
import re
import json
from auth_utils import logger, get_tokens
from os import getenv

client = boto3.client('cognito-idp')
CLIENT_ID = getenv("CLIENT_ID")
required_fields = {"username", "password"}


def log_in(user):
    logger.info(user)
    email, password  = validate_login(user)
    tokens = get_tokens(email, password)
    return tokens


def validate_login(data):
    # Validate required fields exist
    for field in required_fields:
       if field not in data or not isinstance(data[field], str):
           raise ValueError(f"Missing required field '{field}', which must be a string")

    # email and pass
    username = data["username"].lower()
    password = data["password"]
    return  username, password
