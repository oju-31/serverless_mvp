def validate_event(event):
    # Check if event is a dictionary and contains a 'body'
    if not isinstance(event, dict) or 'body' not in event:
        raise ValueError("Event must be a JSON object containing a 'body'")

    body = event["body"]
    return body
