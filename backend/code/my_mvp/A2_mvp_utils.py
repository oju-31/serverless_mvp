import logging
import boto3
import re
from datetime import datetime
from os import getenv
from boto3.dynamodb.conditions import Key

if logging.getLogger().hasHandlers():
    logging.getLogger().setLevel(logging.INFO)
else:
    logging.basicConfig(level=logging.INFO)

logger = logging.getLogger()
cognito_client = boto3.client('cognito-idp')
db = boto3.resource("dynamodb")
CLIENT_ID = getenv("CLIENT_ID")
POOL_ID = getenv("POOL_ID")
USER_TABLE = getenv("USER_TABLE")


# you'd most likely use this function in more than one file
def validate_required_fields(data, required_fields):
    for field, expected_type in required_fields.items():
        if field not in data:
            raise ValueError(f"Missing required field: {field}")
        if not isinstance(data[field], expected_type):
            raise TypeError(f"Field '{field}' must be of type {expected_type.__name__}")