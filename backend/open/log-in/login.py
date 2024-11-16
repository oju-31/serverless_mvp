# import boto3
# import os
# # from login_validation import validator

# POOL_ID = os.environ["POOL_ID"]
# CLIENT_ID = os.environ["CLIENT_ID"]
# CLIENT_SECRET = os.environ["CLIENT_SECRET"]

# client = boto3.client('cognito-idp')
# table_name = os.getenv('ENV')
# table = db.Table(table_name)


# def lambda_handler(event, context):
#     status_code = 400
#     logger.info(event)
#     resp = {
#         "error": True,
#         "success": False,
#         "message": "server error",
#         "data": None
#     }
#     try:
#         username, password = validator(event)
#         response = client.initiate_auth(
#             ClientId=CLIENT_ID,
#             AuthFlow='USER_PASSWORD_AUTH',
#             AuthParameters={
#                  'USERNAME': username,
#                  'PASSWORD': password,
#             },
#             ClientMetadata={
#               'username': username,
#               'password': password,
#             }
#         )
        
#         resp["data"] = {
#                "id_token": response["AuthenticationResult"]["IdToken"],
#                "refresh_token": response["AuthenticationResult"]["RefreshToken"],
#                "access_token": response["AuthenticationResult"]["AccessToken"],
#                "expires_in": response["AuthenticationResult"]["ExpiresIn"],
#                "token_type": response["AuthenticationResult"]["TokenType"]
#             }
#         status_code = 200
#         resp["error"] = False
#         resp["success"] = True
#         resp["message"] = "login successful"
        
#     except ValidationError as e:
#         logger.error(e)
#         resp["message"] = str(e)
#     except client.exceptions.NotAuthorizedException as e:
#         logger.error(e)
#         response_string = str(e)
#         resp["message"] = "Login Failed: Invalid Email or Password"
#     except client.exceptions.UserNotConfirmedException as e:
#         logger.error(e)
#         response_string = str(e)
#         resp["message"] = response_string.split(":", 1)[-1].strip()
#     except client.exceptions.UserNotFoundException as e:
#         logger.error(e)
#         response_string = str(e)
#         resp["message"] = response_string.split(":", 1)[-1].strip()
#     except Exception as e:
#         status_code = 500
#         logger.error(e)
#         resp["message"] = str(e)
    
#     return make_response(status_code, resp)


# def save_cookies(cookies, user_id):
#     cookies.update({"pk": "cookie", "sk": f"user_{user_id}"})
#     table.put_item(Item=cookies)