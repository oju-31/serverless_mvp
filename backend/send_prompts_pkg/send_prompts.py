import boto3
import logging
import create_prompts as c
import random
from raw_data import clothConfig, clothParts
from os import getenv
from botocore.exceptions import BotoCoreError, ClientError
from vldt_send_prompts import validate_event

POOL_ID = getenv('ENV')
CLIENT_ID = getenv('ENV')
cognito_client = boto3.client('cognito-idp')
table_name = getenv('ENV')
# db = boto3.resource("dynamodb")
# table = db.Table(table_name)
clothes = {}

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
        payload = validate_event(event)
        cloth_type, num_prompts = payload["clothType"], payload['numPrompts']
        num_feat = payload["numExtFeatures"]
        main_feat = payload.get("mainFeature", '')
        
        cloth = c.selectFeatures(clothConfig[cloth_type], num_feat, num_prompts)
        all_prompts = ""
        num = 1
        for i in cloth:
            features = c.featured(1, 1, clothParts[cloth_type], main_feat)
            prompt = c.create_clothing_prompts(i, features)
            all_prompts += f"{num}. "
            all_prompts += prompt
            num += 1

        print(all_prompts)
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

