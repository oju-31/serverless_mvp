from A2_mvp_utils import logger, cognito_client, validate_required_fields

required_fields = {"auth": str}


def second_api(info):
    logger.info(info)
    validate_required_fields(info, required_fields)
    name = get_name_from_token(info["auth"])
    return f"Hello {name},This is the second API response, available to logged in users only."


def get_name_from_token(access_token):
    header = cognito_client.get_user(AccessToken = access_token)
    user = {attr.get('Name'): attr.get("Value") for attr in header["UserAttributes"]}
    name = user['given_name']
    return name