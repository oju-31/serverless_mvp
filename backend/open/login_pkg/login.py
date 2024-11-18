import boto3
import os
import logging
from botocore.exceptions import BotoCoreError, ClientError
from validator import validate_event

# POOL_ID = os.environ["POOL_ID"]
# CLIENT_ID = os.environ["CLIENT_ID"]
# CLIENT_SECRET = os.environ["CLIENT_SECRET"]

cognito_client = boto3.client('cognito-idp')
table_name = os.getenv('ENV')
# db = boto3.resource("dynamodb")
# table = db.Table(table_name)

if logging.getLogger().hasHandlers():
    logging.getLogger().setLevel(logging.INFO)
else:
    logging.basicConfig(level=logging.INFO)

logger = logging.getLogger()


def lambda_handler(event, context):
    status_code = 400
    logger.info(event)
    resp = {
        "error": True,
        "success": False,
        "message": "server error",
        "data": None
    }
    try:
        username, password = validate_event(event)
#         response = cognito_client.initiate_auth(
#             ClientId=CLIENT_ID,
#             AuthFlow='USER_PASSWORD_AUTH',
#             AuthParameters={
#                  'USERNAME': username,
#                  'PASSWORD': password,
#             },
#             ClientMetadata={
#               'username': username,
#               'password': password,
#             }
#         )

#         resp["data"] = {
#                "id_token": response["AuthenticationResult"]["IdToken"],
#                "refresh_token": response["AuthenticationResult"]
#                "access_token": response["AuthenticationResult"]
#                "expires_in": response["AuthenticationResult"]["ExpiresIn"],
#                "token_type": response["AuthenticationResult"]["TokenType"]
#             }
#         status_code = 200
#         resp["error"] = False
#         resp["success"] = True
#         resp["message"] = "login successful"

    except ValueError as e:
        logger.error(e)
        resp["message"] = f"A validation error occurred: {str(e)}"
    except (BotoCoreError, ClientError) as e:
        logger.error(e)
        response_string = str(e).split(":", 1)[-1].strip()
        resp["message"] = f"An AWS error occurred: {response_string}"
    except Exception as e:
        status_code = 500
        logger.error(e)
        resp["message"] = str(e)

    return make_response(status_code, resp)


def make_response(status, message, log=True):
    if log:
        logger.info(f"Response: status-{status}, body-{message}")
    return {
        "statusCode": status,
        "body": message
    }
