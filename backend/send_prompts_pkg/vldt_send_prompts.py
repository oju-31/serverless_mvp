# Clothes validation and event validation
clothes = ['top', 'dress', 'gown', 'skirt', "trousers", "shorts", "knicker"]
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
    if main_feature:
        # Split mainFeature into words
        words = main_feature.split()
        # Check if any word in mainFeature is in clothes
        invalid_words = [word for word in words if word in clothes]
        if invalid_words:
            raise ValueError(f"mainFeature must not contain any words from {clothes}. Found: {', '.join(invalid_words)}.")
        if not isinstance(main_feature, str):
            raise ValueError("'mainFeature' must be a string if provided")
    
    # body['mainFeature'] = f'{main_feature} {cloth_type}'
    
    return body

# # Split mainFeature into words
#     words = mainFeature.split()
    
#     # Check for at least two words
#     if len(words) < 2:
#         raise ValueError("mainFeature must contain at least two words.")
    
#     # Check that the last word is in clothes
#     if words[-1] not in clothes:
#         raise ValueError(f"mainFeature must end with one of the words in {clothes}.")
    
#     # Check that only one word from clothes is present
#     matching_clothes = [word for word in words if word in clothes]
#     if len(matching_clothes) > 1:
#         raise ValueError("mainFeature must contain only one word from clothes, which must be the last word.")