from datetime import datetime
from A2_user_utils import logger, validate_required_fields, db, USER_TABLE, get_user_from_table, get_user_id_from_token, cognito_client

required_fields = {"auth": str}
allowed_update_fields = {"given_name", "family_name"}


def update_user_info(user_data):
    logger.info(f"Updating user: {user_data}")
    user_id, auth, update_fields = validate_update_user(user_data)
    # Get existing user from table
    existing_user = get_user_from_table(user_id)
    # Update the user object and Put the updated user back to table

    put_user_to_table(existing_user, update_fields)
    update_cognito_user(auth, update_fields)
    return "User updated successfully"


def update_cognito_user(access_token, update_fields):
    """Update user attributes in Cognito"""
    # Map update fields to Cognito attributes
    cognito_mapping = {
        "given_name": "given_name",
        "family_name": "family_name"
    }

    # Build user attributes list
    user_attributes = [
        {'Name': cognito_mapping[field], 'Value': value}
        for field, value in update_fields.items()
        if field in cognito_mapping
    ]

    cognito_client.update_user_attributes(
        AccessToken=access_token,
        UserAttributes=user_attributes
    )


def put_user_to_table(user, fields):
    user.update(fields)
    user['updated_at'] = datetime.now().isoformat()
    table = db.Table(USER_TABLE)
    table.put_item(Item=user)


def validate_update_user(data):
    validate_required_fields(data, required_fields)
    auth = data["auth"]
    user_id = get_user_id_from_token(auth)
    # Extract update fields (excluding user_id)
    update_fields = {k: v for k, v in data.items() if k in allowed_update_fields}
    if not update_fields:
        raise ValueError("No fields provided for update")
    # Validate that all update field values are strings
    for field_name, field_value in update_fields.items():
        if not isinstance(field_value, str):
            raise TypeError(f"Field '{field_name}' must be a string, got {type(field_value).__name__}")

    return user_id, auth, update_fields