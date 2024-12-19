import boto3
import logging
import json
import create_prompts as c
from uuid import uuid4
from raw_data import clothConfig, clothParts
from os import getenv
from urllib import request
from botocore.exceptions import BotoCoreError, ClientError
from vldt_send_prompts import validate_event

# get environment variables
OPENAI_API_KEY = getenv('OPENAI_API_KEY')
table_name = getenv('ENV')

# POOL_ID = getenv('ENV')
# CLIENT_ID = getenv('ENV')
# cognito_client = boto3.client('cognito-idp')
# db = boto3.resource("dynamodb")
#table = db.Table(table_name)
openai_url = 'https://api.openai.com/v1/images/generations'
headers = {
    'Content-Type': 'application/json',
    'Authorization': f'Bearer {OPENAI_API_KEY}'
}
if logging.getLogger().hasHandlers():
    logging.getLogger().setLevel(logging.INFO)
else:
    logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()


def lambda_handler(event, context):
    status_code = 400
    logger.info(event)
    resp = {
        "status": 'Error',
        "message": "server error"
    }

    try:
        payload, token = validate_event(event)
        auth_header = cognito_client.get_user(AccessToken=token)
        user = {attr.get("Name"): attr.get("Value") for attr in auth_header["UserAttributes"]}
        user_id = f"user_{user['sub']}"
        album_id = f"album_{str(uuid4())[:8]}"
        cloth_type, num_prompts = payload["clothType"], payload['numPrompts']
        num_feat = payload["numExtFeatures"]
        main_feat = payload.get("mainFeature", '')
        data = {
            'model': 'dall-e-3',
            'n': 1,
            'size': '1024x1024'
        }
        cloth = c.selectFeatures(clothConfig[cloth_type], num_feat, num_prompts)
        all_prompts = ""
        num = 1
        for i in cloth:
            features = c.featured(1, 1, clothParts[cloth_type], main_feat)
            prompt = c.create_clothing_prompts(i, cloth_type, features)
            data['prompt'] = prompt
            data = json.dumps(data).encode('utf-8')
            req = request.Request(openai_url,
                     headers=headers, 
                     data=data, 
                     method='POST')
            img_id = f"album_{str(uuid4())[:10]}"
            all_prompts += f"{num}. "
            all_prompts += prompt
            num += 1
        print(all_prompts)
        resp = {
            "status": 'Success',
            "message": "Prompts generated successfully"
        }
    except ValueError as e:
        logger.error(e)
        resp["message"] = f"A validation error occurred: {str(e)}"
    except (BotoCoreError, ClientError) as e:
        logger.error(e)
        resp_string = str(e).split(":", 1)[-1].strip()
        resp["message"] = f"An AWS error occurred: {resp_string}"
    except Exception as e:
        status_code = 500
        logger.error(e)
        resp["message"] = str(e)

    # return make_response(status_code, resp)
    return make_response(status_code, resp)

def make_response(status, message, log=True):
    if log:
        logger.info(f"Response: status-{status}, body-{message}")
    return {
        "statusCode": status,
        "body": message
    }

test_event = {
  "body":{
    "clothType": "shorts",
    "numPrompts": 5,
    "numExtFeatures": 4,
    "mainFeature": "black and white"
  }
}
lambda_handler(test_event, None)
