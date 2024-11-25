import os
import re


def validate_input(name: str, input_type: str) -> bool:
    """
    Validates that the input string contains only alphanumeric
    characters and underscores.
    Returns True if valid, raises ValueError if invalid.
    """
    pattern = re.compile(r'^[a-zA-Z0-9_]+$')
    if not pattern.match(name):
        raise ValueError(f"{input_type} must contain only letters, numbers, and underscores")
    return True


def create_backend(module_name: str, api_name: str):
    # Define base paths
    backend_path = "backend"
    tests_path = os.path.join(backend_path, "unit_tests")
    module_path = os.path.join(backend_path, module_name)
    api_pkg_path = os.path.join(module_path, f"{api_name}_pkg")

    # Create backend folder if it doesn't exist
    os.makedirs(backend_path, exist_ok=True)
    os.makedirs(tests_path, exist_ok=True)

    # Create module folder if it doesn't exist
    if not os.path.exists(module_path):
        os.makedirs(module_path)
        print(f"Created module folder: {module_path}")

    # Create api package folder
    os.makedirs(api_pkg_path, exist_ok=True)
    print(f"Created API package folder: {api_pkg_path}")

    # Create api_name.py
    api_code = f'''import boto3
import os
import logging
from botocore.exceptions import BotoCoreError, ClientError
from vldt_{api_name} import validate_event

# POOL_ID = os.environ["POOL_ID"]
# CLIENT_ID = os.environ["CLIENT_ID"]
# CLIENT_SECRET = os.environ["CLIENT_SECRET"]
cognito_client = boto3.client('cognito-idp')
table_name = os.getenv('ENV')
# db = boto3.resource("dynamodb")
# table = db.Table(table_name)

if logging.getLogger().hasHandlers():
    logging.getLogger().setLevel(logging.INFO)
else:
    logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

def lambda_handler(event, context):
    status_code = 400
    logger.info(event)
    resp = {{
        "error": True,
        "success": False,
        "message": "server error",
        "data": None
    }}

    try:
        username, password = validate_event(event)
    except ValueError as e:
        logger.error(e)
        resp["message"] = f"A validation error occurred: {{str(e)}}"
    except (BotoCoreError, ClientError) as e:
        logger.error(e)
        response_string = str(e).split(":", 1)[-1].strip()
        resp["message"] = f"An AWS error occurred: {{response_string}}"
    except Exception as e:
        status_code = 500
        logger.error(e)
        resp["message"] = str(e)

    return make_response(status_code, resp)

def make_response(status, message, log=True):
    if log:
        logger.info(f"Response: status-{{status}}, body-{{message}}")
    return {{
        "statusCode": status,
        "body": message
    }}
'''

    validate_code = '''def validate_event(event):
    # Check if event is a dictionary and contains a 'body'
    if not isinstance(event, dict) or 'body' not in event:
        raise ValueError("Event must be a JSON object containing a 'body'")

    body = event["body"]
    return body
'''

    # Write api_name.py
    api_file_path = os.path.join(api_pkg_path, f"{api_name}.py")
    with open(api_file_path, 'w') as f:
        f.write(api_code.replace('api_name', api_name))
    print(f"Created API file: {api_file_path}")

    # Write validate_api_name.py
    validate_file_path = os.path.join(api_pkg_path, f"vldt_{api_name}.py")
    with open(validate_file_path, 'w') as f:
        f.write(validate_code)
    print(f"Created validate file: {validate_file_path}")

    # Create test folder and file
    test_module_path = os.path.join(tests_path, f"{module_name}_tests")
    os.makedirs(test_module_path, exist_ok=True)

    test_file_path = os.path.join(test_module_path, f"test_{api_name}.py")
    with open(test_file_path, 'w') as f:
        f.write(f"# Test file for {api_name}")
    print(f"Created test file: {test_file_path}")

    return True


def append_infra_code(module_name: str, api_name: str):
    # Define the base path and file paths
    base_path = "infra/lambdas"
    files = {
        "data": f"{base_path}/func_data.tf",
        "main": f"{base_path}/func_main.tf",
        "policies": f"{base_path}/func_policies.tf",
        "roles": f"{base_path}/func_roles.tf"
    }

    # Data file content
    data_content = f'''
data "archive_file" "{api_name}" {{
  type        = "zip"
  source_dir  = "${{path.root}}/backend/{module_name}/{api_name}_pkg"
  output_path = "${{path.root}}/backend/{module_name}/zip/{api_name}.zip"
}}'''

    # Main file content
    main_content = f'''
# ---------------------------------------
# {api_name.upper()} LAMBDA
#----------------------------------------
resource "aws_lambda_function" "{api_name}" {{
  filename         = "${{path.root}}/backend/{module_name}/zip/{api_name}.zip"
  function_name    = "${{var.RESOURCE_PREFIX}}-{api_name}-${{local.LAMBDA_VERSION}}"
  role             = "${{aws_iam_role.{api_name}.arn}}"
  handler          = "{api_name}.lambda_handler"
  source_code_hash = data.archive_file.{api_name}.output_base64sha256
  runtime          = local.PYTHON_VERSION
  timeout          = 300
  tags             = local.TAGS
  environment {{
    variables = {{
      ENV           = "${{var.ENV}}"
    }}
  }}
}}
resource "aws_lambda_function_url" "{api_name}" {{
  function_name      = aws_lambda_function.{api_name}.function_name
  authorization_type = "NONE"
}}'''

    # Policies file content
    policies_content = f'''
# -------------------------------------------------
# {api_name.upper()} POLICY
#--------------------------------------------------
resource "aws_iam_role_policy" "{api_name}" {{
  name = "${{var.RESOURCE_PREFIX}}-lambda-{api_name}-policy"
  role = aws_iam_role.{api_name}.id
   policy = jsonencode({{
    Version = "2012-10-17"
    Statement = [
      {{
        Effect = "Allow",
        Action = "*",
        Resource = [
          "*"
        ]
      }}
    ]
  }})
}}'''

    # Roles file content
    roles_content = f'''
# ---------------------------------------
# {api_name.upper()} ROLE
#----------------------------------------
resource "aws_iam_role" "{api_name}" {{
   name = "${{var.RESOURCE_PREFIX}}-lambda-{api_name}-role"
   assume_role_policy = jsonencode({{
     "Version" : "2012-10-17",
     "Statement" : [
       {{
         "Action" : "sts:AssumeRole",
         "Principal" : {{
           "Service" : "lambda.amazonaws.com"
         }},
         "Effect" : "Allow",
         "Sid" : ""
       }}
     ]
   }})
 }}'''

    # Dictionary mapping file types to their content
    contents = {
        "data": data_content,
        "main": main_content,
        "policies": policies_content,
        "roles": roles_content
    }

    # Append content to each file
    for file_type, file_path in files.items():
        try:
            with open(file_path, 'a') as f:
                f.write(contents[file_type])
            print(f"Successfully appended to {file_path}")
        except FileNotFoundError:
            print(f"Error: File not found - {file_path}")
        except Exception as e:
            print(f"Error writing to {file_path}: {str(e)}")

    return True


def create_api(module, api):
    try:
        validate_input(module, "Module name")
        validate_input(api, "API name")
    except ValueError as e:
        print(f"Input validation error: {str(e)}")
        return False
    create_backend(module, api)
    append_infra_code(module, api)


create_api("ttt uua", "api jj")
