import boto3
from auth_utils import logger
from os import getenv

client = boto3.client('cognito-idp')
CLIENT_ID = getenv("CLIENT_ID")


def refresh_token(user):
    logger.info(user)
    r_token = validate_resend_code(user)
    resp = client.initiate_auth(
        ClientId=CLIENT_ID,
        AuthFlow="REFRESH_TOKEN_AUTH",
        AuthParameters={"REFRESH_TOKEN": r_token}
    )
    result = {}
    if resp.get("AuthenticationResult"):
        # result["id_token"] = resp["AuthenticationResult"]["IdToken"]
        result["access_token"] = resp["AuthenticationResult"]["AccessToken"]
    return result


def validate_resend_code(data):
    # Validate required fields exist
    token = "refresh_token"
    if token not in data or not isinstance(data[token], str):
           raise ValueError(f"Missing required field '{token}', which must be a string")
    return data[token]