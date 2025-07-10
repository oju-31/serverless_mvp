from A2_mvp_utils import logger, CLIENT_ID, cognito_client

required_fields = {}


def first_api(info):
    logger.info(info)
    
    return "This is the first API response, available to everyone."

