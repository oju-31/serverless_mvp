from A2_user_utils import logger, validate_required_fields, validate_email_pattern, cognito_client, CLIENT_ID

required_fields = {
    "email": str, 
    "password": str, 
    "full_name": str, 
    "agreed_to_terms": bool
}


def sign_up(new_user):
    logger.info(new_user)
    user = validate_signup(new_user)
    email, password, attr = get_attributes(user)
    cognito_client.sign_up(
        ClientId=CLIENT_ID,
        Username=email,
        Password=password,
        UserAttributes=attr,
        ValidationData=[
            {
                'Name': "email",
                'Value': email
            }
        ]
    )
    return "Code sent to your email, please confirm your account"


def validate_signup(data):
    # Validate required fields exist
    validate_required_fields(data, required_fields)
    if data["agreed_to_terms"] != True:
        raise ValueError("You must agree to our terms to use the app")
    # email and pass
    username = data["email"].lower()
    password = data["password"]
    validate_email_pattern(username)
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
    return  data 


def get_attributes(payload):
    e_mail = payload["email"].lower()
    password = payload["password"]
    attributes = [
            {
                'Name': "email",
                'Value': payload["email"].lower()
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
