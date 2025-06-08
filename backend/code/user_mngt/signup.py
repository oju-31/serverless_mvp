import boto3
import re
from decimal import Decimal
from datetime import datetime
from auth_utils import logger, db, admin_get_user, get_tokens
from os import getenv

client = boto3.client('cognito-idp')
POOL_ID = getenv("POOL_ID")
CLIENT_ID = getenv("CLIENT_ID")
table_name = getenv("USER_TABLE")
required_fields = {"username", "password", "agreed_to_terms", "full_name"}


def sign_up(new_user):
    logger.info(new_user)
    user = validate_signup(new_user)
    email, password, attr = get_attributes(user)
    confirm_sigup(email, password, attr)
    user_data = admin_get_user(client, POOL_ID, email)
    customer = {
        "userID": f"user_{user_data['sub']}",
        'created_at': datetime.now().isoformat(),
    }
    del user_data['sub']
    customer.update(user_data)
    table = db.Table(table_name)
    table.put_item(Item=customer)
    tokens = get_tokens(email, password)
    return tokens


def confirm_sigup(username, password, attr):
    client.sign_up(
        ClientId=CLIENT_ID,
        Username=username,
        Password=password,
        UserAttributes=attr,
        ValidationData=[
            {
                'Name': "email",
                'Value': username
            }
        ]
    )
    client.admin_confirm_sign_up(
        UserPoolId=POOL_ID,
        Username=username
    )
    # Mark email as verified
    client.admin_update_user_attributes(
        UserPoolId=POOL_ID,
        Username=username,
        UserAttributes=[
            {
                'Name': 'email_verified',
                'Value': 'true'
            }
        ]
    )


def validate_signup(data):
    # Validate required fields exist
    for field in required_fields:
       if field not in data or data[field] is None:
           raise ValueError(f"Missing required field '{field}'")

    # email and pass
    username = data["username"]
    password = data["password"]
    email_pattern = r"[^@]+@[^@]+\.[^@]+"
    if not re.match(email_pattern, username):
        raise ValueError("Invalid email format")
    if len(password) < 8:
        raise ValueError("Password must be at least 8 characters long")

    # full_name validation
    full_name = data["full_name"]
    if not isinstance(full_name, str) or len(full_name.strip().split()) < 1:
        raise ValueError("'full_name' must be a string with at least one name")
    name_parts = full_name.strip().split()
    # Ensure each part of the name is at least 3 letters
    for part in name_parts:
        if len(part) < 3:
            raise ValueError("Each part of 'full_name' must be at least 3 characters long")
    data["first_name"] = name_parts[0]
    data["surname"] = name_parts[1] if len(name_parts) > 1 else ""
    # terms agreement
    agreed = data["agreed_to_terms"]
    if not isinstance(agreed, bool) or not agreed:
        raise ValueError("You must explicitly agree to the Terms of Service to sign up, must be a boolean")
    return  data 


def get_attributes(payload):
    e_mail = payload["username"].lower()
    password = payload["password"]
    attributes = [
            {
                'Name': "email",
                'Value': payload["username"].lower()
            },
            {
                'Name': "family_name",
                'Value': payload["surname"].capitalize()
            },
            {
                'Name': "nickname",
                'Value': payload["first_name"].lower()
            },
            {
                'Name': "given_name",
                'Value': payload["first_name"].capitalize()
            }
        ]
    return e_mail, password, attributes
