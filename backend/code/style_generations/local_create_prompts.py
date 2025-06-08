import logging
import backend.code.style_generations.create_images as c
from uuid import uuid4
from raw_data import clothConfig, clothParts
from urllib import request

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
        payload = event.get("body")
        cloth_type, num_prompts = payload["clothType"], payload['numPrompts']
        num_feat = payload["numExtFeatures"]
        main_feat = payload.get("mainFeature", '')
        
        cloth = c.selectFeatures(clothConfig[cloth_type], num_feat, num_prompts)
        print(cloth)
        all_prompts = ""
        num = 1
        for i in cloth:
            features = c.featured(1, clothParts[cloth_type], main_feat)
            prompt = c.create_clothing_prompts(i, cloth_type, features)
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
    "clothType": "dress",
    "numPrompts": 5,
    "numExtFeatures": 4,
    "mainFeature": "tiered dress"
  }
}
lambda_handler(test_event, None)
