

def validate_event(event):
    # Check if event is a dictionary and contains a 'body'
    if not isinstance(event, dict) or 'body' not in event:
        raise ValueError("Event must be a JSON object containing a 'body'")

    body = event["body"]

    # Check if 'username' and 'password' are in the body and are strings
    pre_check1 = 'username' not in body or 'password' not in body
    if not isinstance(body, dict) or pre_check1:
        raise ValueError("Body must contain 'username' and 'password' fields")

    username = body["username"]
    password = body["password"]

    if not isinstance(username, str) or not isinstance(password, str):
        raise ValueError("'username' and 'password' must be strings")

    return username, password
