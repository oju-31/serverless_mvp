import logging
import boto3
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


def admin_get_user(cognito_client, user_pool_id, username):
    response = cognito_client.admin_get_user(
        UserPoolId=user_pool_id,
        Username=username
    )
    data = {
        attr.get('Name'): attr.get("Value") for attr in response["UserAttributes"]
    }
    return data


def get_user(table, user_id):
    response = table.query(KeyConditionExpression=Key('userID').eq(user_id),
                        ScanIndexForward=False
                )
    items = response.get('Items', [])
    
    if not items:
        raise ValueError(f"User with ID '{user_id}' not found.")
    
    return items[0]

 
def get_user_id_from_token(access_token):
    header = cognito_client.get_user(
            AccessToken = access_token
        )
    user = {
        attr.get('Name'): attr.get("Value") for attr in header["UserAttributes"]
    }
    user_id = f'user_{user['sub']}'
    return user_id


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
