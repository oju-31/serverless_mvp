import traceback
import json
from A2_user_utils import logger
from confirm_forgot_password import confirm_forgot_pass
from confirm_signup import confirm_sign_up
from delete_user import delete_user_info
from disable_user import disable_user_acct
from enable_user import enable_user_acct
from forgot_password import forgot_pass
from get_user import get_user_info
from login import log_in
from signup import sign_up
from update_user import update_user_info  
from botocore.exceptions import BotoCoreError, ClientError

dispatch_map = {
    "confirm_forgot_password": confirm_forgot_pass,
    "confirm_signup": confirm_sign_up,
    "delete_user": delete_user_info,
    "disable_user": disable_user_acct,
    "enable_user": enable_user_acct,
    "forgot_password": forgot_pass,
    "get_user": get_user_info,
    "login": log_in,
    "signup": sign_up,
    "update_user": update_user_info,
}
allowed_types = set(dispatch_map.keys())
auth_required = {"delete_user", "get_user", "update_user", "disable_user"}


def lambda_handler(event, context):
    status_code = 400
    logger.info(event)
    resp = {
        "status": "Error",
        "message": "server error",
    }
    try:
        request_type, body = validate_event(event)
        handler_function = dispatch_map.get(request_type)
        message = handler_function(body)
        status_code = 200
        resp["status"] = "Success"
        resp["message"] = message
    except ValueError as e:
        logger.error(e)
        resp["message"] = f"A validation error occurred: {str(e)}"
    except KeyError:
        resp["message"] = traceback.print_exc()
    except (BotoCoreError, ClientError) as e:
        logger.error(e)
        response_string = str(e).split(":", 1)[-1].strip()
        resp["message"] = f"An AWS error occurred: {response_string}"
    except Exception as e:
        status_code = 500
        logger.error(e)
        resp["message"] = str(e)
        resp["data"] = traceback.print_exc()
    return create_response(status_code, resp)


def validate_event(event):
    # Check if event is a dictionary and contains a 'body'
    if not isinstance(event, dict) or 'body' not in event:
        raise ValueError("Event must be a JSON object containing a 'body'")

    try:
        body = json.loads(event["body"])
    except json.JSONDecodeError:
        raise ValueError("Invalid JSON in body")

    # Check for 'type' in body and validate its value
    if "type" not in body:
        raise ValueError("Missing 'type' field in request body")
    if body["type"] not in allowed_types:
        raise ValueError(f"'type' must be one of {', '.join(allowed_types)}")
    
    # Check for authorization in headers if type is exactly "onboarding"
    if body["type"] in auth_required:
        if "headers" not in event or not event["headers"]:
            raise ValueError(f"headers is required for these {', '.join(auth_required)} request")
        header = event["headers"]
        if "Authorization" not in header and "authorization" not in header:
            raise ValueError(f"Authorization header is required for these {', '.join(auth_required)} requests")
        auth = header.get("Authorization") or header.get("authorization")
        if not isinstance(auth, str):
            raise ValueError("Authorization header is must be a string")
        body["auth"] = auth

    return body["type"], body


def create_response(status, message, log=True):
    if log:
        logger.info(f"Response: status-{status}, body-{message}")
    return {
        "statusCode": status,
        "body": message
    }