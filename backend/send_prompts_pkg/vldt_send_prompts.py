# Clothes validation and event validation
clothes = ['top', 'dress', 'gown', 'skirt', "trouser", "short", "knicker"]
req_params = ['clothType', 'numPrompts', 'numExtFeatures']

def validate_event(event):
    # Check if event is a dictionary and contains a 'body'
    if not isinstance(event, dict) or 'body' not in event:
        raise ValueError("Event must be a JSON object containing a 'body'")
    body = event["body"]
    # Check if body is a dictionary
    if not isinstance(body, dict):
        raise ValueError("'body' must be a JSON object")
    # Ensure all required parameters are present in the body
    missing_params = [param for param in req_params if param not in body]
    if missing_params:
        raise ValueError(f"Missing required parameters in 'body': {', '.join(missing_params)}")
     # Validate the value of clothType
    cloth_type = body.get("clothType")
    if cloth_type not in clothes:
        raise ValueError(f"'clothType' must be one of {clothes}")
    
    # Validate numPrompts and numExtFeatures are integers
    if not isinstance(body["numPrompts"], int):
        raise ValueError("'numPrompts' must be an integer")
    if not isinstance(body.get("numExtFeatures"), int):
        raise ValueError("'numExtFeatures' must be an integer")
    
    # Validate mainFeature if present
    main_feature = body.get("mainFeature")
    if main_feature and not isinstance(main_feature, str):
        raise ValueError("'mainFeature' must be a string if provided")

    return body