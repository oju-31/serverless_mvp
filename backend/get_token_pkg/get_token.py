import json
import urllib.parse
import urllib.request
import urllib.error
import logging
import base64
from os import getenv
from vldt_get_token import validate_event

client_id =  getenv('COGNITO_CLIENT_ID')
client_secret =  getenv('COGNITO_CLIENT_SECRET')
redirect_uri =  getenv('HOME_PAGE')
token_endpoint = getenv('COGNITO_TOKEN_ENDPOINT')

if logging.getLogger().hasHandlers():
    logging.getLogger().setLevel(logging.INFO)
else:
    logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

def lambda_handler(event, context):
    status_code = 400
    head = {}
    logger.info(event)
    resp = {
        "status": "Error",
        "message": "server error"
    }

    try:
        code = validate_event(event)
        data = urllib.parse.urlencode({
            'grant_type': 'authorization_code',
            'client_id': client_id,
            'client_secret': client_secret,
            'code': code,
            'redirect_uri': redirect_uri
        }).encode('utf-8')
        headers = {'Content-Type': 'application/x-www-form-urlencoded'}
        request = urllib.request.Request(
            token_endpoint,
            data=data,
            headers=headers,
            method='POST'
        )
        # Make the request
        with urllib.request.urlopen(request) as response:
            response_body = response.read().decode('utf-8')
            tokens = json.loads(response_body)
            access_token = tokens['access_token']
            status_code = 200
            head = {
                'Set-Cookie': f"access_token={access_token}; Secure; HttpOnly; Path=/",
                'Content-Type': 'application/json'
            }
            resp["message"] = "Tokens stored in cookies"
        # Basic structural validation
        parts = access_token.split('.')
        if len(parts) != 3:
            raise ValueError("token validation fail")
        # JWT is base64 encoded, so split and decode middle part
        payload_base64 = access_token.split('.')[1]
        
        # Add padding if needed
        payload_base64 += '=' * (4 - len(payload_base64) % 4)
        
        # Decode payload
        payload_json = base64.b64decode(payload_base64).decode('utf-8')
        payload = json.loads(payload_json)
        
        # 'exp' is standard JWT claim for expiration (Unix timestamp)
        if 'exp' in payload:
            expiry_timestamp = payload['exp']
            # expiry_datetime = datetime.fromtimestamp(expiry_timestamp)
            resp["expiry"] = expiry_timestamp
    except urllib.error.HTTPError as e:
        status_code = e.code
        e_message = e.read().decode('utf-8')
        logger.error(e_message)
        resp["message"] = f"HTTP Error : {str(e_message)}"
    except urllib.error.URLError as e:
        status_code = e.code
        logger.error(e)
        resp["message"] = f"A validation error occurred: {str(e)}"
    except ValueError as e:
        logger.error(e)
        resp["message"] = f"A validation error occurred: {str(e)}"
    except Exception as e:
        status_code = e.code
        logger.error(e)
        resp["message"] = str(e)

    return make_response(status_code, head, resp)


def make_response(status, message, headers, log=True):
    if log:
        logger.info(f"Response: status-{status}, body-{message}")
    return {
        "statusCode": status,
        "headers": headers,
        "body": message
    }
