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

# if you use the same function in more than one file, you can put it here

# used twice, passed
def get_user_from_table(user_id):
    table = db.Table(USER_TABLE)
    response = table.get_item(Key={'userID': user_id})
    if 'Item' in response:
        return response['Item']
    else:
        raise ValueError("User not found")


# used twice, passed
def get_user_id_from_token(access_token):
    header = cognito_client.get_user(
            AccessToken = access_token
        )
    user = {
        attr.get('Name'): attr.get("Value") for attr in header["UserAttributes"]
    }
    user_id = f'user_{user['sub']}'
    return user_id

# used twice, passed
def get_tokens(user, code):
    response = cognito_client.initiate_auth(
        ClientId=CLIENT_ID,
        AuthFlow='USER_PASSWORD_AUTH',
        AuthParameters={
                'USERNAME': user,
                'PASSWORD': code,
        },
        ClientMetadata={
            'username': user,
            'password': code,
        }
    )
    token  = {
            "refresh_token": response["AuthenticationResult"]["RefreshToken"],
            "access_token": response["AuthenticationResult"]["AccessToken"],
            "expires_in": response["AuthenticationResult"]["ExpiresIn"],
            "token_type": response["AuthenticationResult"]["TokenType"]
        }
    return token

# used twice, passed
def get_user_from_token(access_token):
    header = cognito_client.get_user(AccessToken = access_token)
    user = {attr.get('Name'): attr.get("Value") for attr in header["UserAttributes"]}
    user_email = user['email']
    return user_email, f"user_{user['sub']}"


# used twice, passed
def update_user_status(user_id, status):
    table = db.Table(USER_TABLE)
    table.update_item(
        Key={'userID': user_id},
        UpdateExpression='SET #status = :status, updated_at = :updated_at',
        ExpressionAttributeNames={'#status': 'status'},
        ExpressionAttributeValues={
            ':status': status,
            ':updated_at': datetime.now().isoformat()
        }
    )


# used twice, passed
def validate_required_fields(data, required_fields):
    for field, expected_type in required_fields.items():
        if field not in data:
            raise ValueError(f"Missing required field: {field}")
        if not isinstance(data[field], expected_type):
            raise TypeError(f"Field '{field}' must be of type {expected_type.__name__}")


# used twice, passed     
def validate_email_pattern(e_mail):
    email_pattern = r"[^@]+@[^@]+\.[^@]+"
    if not re.match(email_pattern, e_mail):
        raise ValueError("Invalid email format")
    return e_mail.lower()