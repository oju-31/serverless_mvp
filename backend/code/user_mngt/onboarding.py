import boto3
import re
from decimal import Decimal
from datetime import datetime
from auth_utils import logger, db, get_user, get_user_id_from_token
from os import getenv

client = boto3.client('cognito-idp')
POOL_ID = getenv("POOL_ID")
CLIENT_ID = getenv("CLIENT_ID")
table_name = getenv("USER_TABLE")
required_fields = {
    "goal", "sex", "age", "height", 
    "weight", "allergies", "diet"
   }
allowed_goals = {"maintaining", "bulking", "meal planning", "cutting"}
allowed_sex = {"male", "female"}
allowed_diets = {"classic", "low carb", "paleo", "keto"}
allowed_height_units = {"cm", "ft"}
allowed_weight_units = {"kg", "lb"}
# Sample allergies list
allowed_allergies = {
    "none", "gluten", "peanuts", "shellfish", "soy", "dairy", "tree nuts", "eggs", "fish", "sesame"
}


def onboard(new_user):
    logger.info(new_user)
    user = validate_signup(new_user)
    table = db.Table(table_name)
    user_id = get_user_id_from_token(user["auth"])
    del user["auth"] 
    old_user_info = get_user(table, user_id)
    store_user_in_table(old_user_info, user)
    return "Onboarding successful"


def validate_signup(data):
    # Validate required fields exist
    for field in required_fields:
       if field not in data or data[field] is None:
           raise ValueError(f"Missing required field '{field}'")

    _check_in("goal", data["goal"], allowed_goals)
    _check_in("sex", data["sex"], allowed_sex)
    _check_in("diet", data["diet"], allowed_diets)

     # Allergies
    allergies = data.get("allergies")
    if not allergies or not isinstance(allergies, list):
        raise ValueError("'allergies' must be a list with at least one item")
    invalid_allergies = [a for a in allergies if a.lower() not in allowed_allergies]
    if invalid_allergies:
        raise ValueError(f"Invalid allergies: {', '.join(invalid_allergies)}")

    # age
    age = data["age"]
    if not isinstance(age, int) or not (10 <= age <= 120):
        raise ValueError("'age' must be an integer between 10 and 120")
    
    # Height & weight with 2-decimal floats
    _check_measure("height", data["height"], allowed_height_units)
    _check_measure("weight", data["weight"], allowed_weight_units)

    return  data 


def _check_in(field, value, allowed):
    if value.lower() not in allowed:
        raise ValueError(f"'{field}' must be one of: {', '.join(allowed)}")


def _check_measure(field, meas, allowed_units):
    if (
        not isinstance(meas, dict)
        or "value" not in meas
        or "unit" not in meas
    ):
        raise ValueError(f"'{field}' must be an object with 'value' and 'unit' properties")
    value = meas["value"]
    unit = meas["unit"]
    _check_in("unit", unit, allowed_units)
    if not isinstance(value, (int, float)) or value <= 0:
        raise ValueError(f"'{field}' value must be a positive number")
    # Round to 2 decimal places if it's a float
    if isinstance(value, float):
        meas["value"] = round(value, 2)


def store_user_in_table(old_info, new_data):
    """Update user data in DynamoDB"""
    # Convert height and weight to standard units (centimeters and kilograms)
    standard_height = convert_to_standard_height(new_data['height'])
    standard_weight = convert_to_standard_weight(new_data['weight'])
    table = db.Table(table_name)
    # Prepare item for DynamoDB
    old_info.update({
        'updated_at': datetime.now().isoformat(),
        'height': standard_height,  # Store in centimeters
        'height_unit': 'cm',  # Standard unit
        'preferred_height_unit': new_data['height']['unit'],  # Store preference
        'weight': standard_weight,  # Store in kilograms
        'weight_unit': 'kg',  # Standard unit
        'preferred_weight_unit': new_data['weight']['unit'],  # Store preference
    })
    new_data.update(old_info)
    table.put_item(Item=new_data)


def convert_to_standard_height(height_info):
    unit = height_info['unit']
    value = height_info['value']
    """Convert height to meters"""
    if unit == 'ft':
        return Decimal(str(value * 30.48))
    elif unit == 'cm':
        return Decimal(str(value))
    else:
        raise ValueError(f"Unsupported height unit: {unit}")


def convert_to_standard_weight(weight_info):
    unit = weight_info['unit']
    value = weight_info['value']
    """Convert weight to kilograms"""
    if unit == 'lb':
        return Decimal(str(value * 0.45359237))
    elif unit == 'kg':
        return Decimal(str(value))
    else:
        raise ValueError(f"Unsupported weight unit: {unit}")
