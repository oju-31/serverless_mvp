from datetime import datetime
from A2_user_utils import logger, validate_required_fields, CLIENT_ID, cognito_client, db, USER_TABLE, validate_email_pattern, POOL_ID

required_fields = {"code": str, "email": str}


def confirm_sign_up(user):
    logger.info(user)
    email, confirmation_code = validate_confirm_signup(user)
    # Confirm the user in Cognito
    cognito_client.confirm_sign_up(
        ClientId=CLIENT_ID,
        Username=email,
        ConfirmationCode=confirmation_code
    )
    # Get user data from Cognito after confirmation
    user_data = admin_get_user(email)
    # Create user record for database
    customer = format_user_info(user_data)
    add_user_2_table(customer)
    return "User confirmed successfully"


def add_user_2_table(user):
    table = db.Table(USER_TABLE)
    table.put_item(Item=user)


def format_user_info(user):
    formated = {
        "userID": f"user_{user['sub']}",
        'created_at': datetime.now().isoformat(),
        'updated_at': datetime.now().isoformat(),
        'status': 'ACTIVE'
    }
    # Remove 'sub' and add remaining user attributes
    del user['sub']
    formated.update(user)
    return formated


def validate_confirm_signup(data):
    validate_required_fields(data, required_fields)
    # email and code
    email = data["email"].lower()
    code = data["code"]
    validate_email_pattern(email)
    return  email, code


def admin_get_user(e_mail):
    response = cognito_client.admin_get_user(
        UserPoolId=POOL_ID,
        Username=e_mail
    )
    data = {
        attr.get('Name'): attr.get("Value") for attr in response["UserAttributes"]
    }
    return data