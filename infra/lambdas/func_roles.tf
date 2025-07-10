# ---------------------------------------
# USER MNGT ROLE 
#----------------------------------------
resource "aws_iam_role" "user_mngt" {
   name = "user_mngt-lambda-role-${var.RESOURCE_PREFIX}"
   assume_role_policy = jsonencode({
     "Version" : "2012-10-17",
     "Statement" : [
       {
         "Action" : "sts:AssumeRole",
         "Principal" : {
           "Service" : "lambda.amazonaws.com"
         },
         "Effect" : "Allow",
         "Sid" : ""
       }
     ]
   })
 }
 
# Least privileged inline policy for user management lambda
resource "aws_iam_role_policy" "user_mngt" {
  name = "user_mngt-policy-${var.RESOURCE_PREFIX}"
  role = aws_iam_role.user_mngt.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "CloudWatchLogsPermissions"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = [
          "${aws_lambda_function.user_mngt.arn}",
          "${aws_lambda_function.user_mngt.arn}:*"
        ]
      },
      {
        Sid = "CognitoUserPoolPermissions"
        Effect = "Allow"
        Action = [
          "cognito-idp:SignUp",
          "cognito-idp:ConfirmSignUp",
          "cognito-idp:InitiateAuth",
          "cognito-idp:GetUser",
          "cognito-idp:UpdateUserAttributes",
          "cognito-idp:DeleteUser",
          "cognito-idp:ForgotPassword",
          "cognito-idp:ConfirmForgotPassword"
        ]
        Resource = [
          "arn:aws:cognito-idp:*:*:userpool/*"
        ]
        Condition = {
          "ForAllValues:StringEquals" = {
            "cognito-idp:ClientId" = "${var.CLIENT_ID}"
          }
        }
      },
      {
        Sid = "CognitoAdminPermissions"
        Effect = "Allow"
        Action = [
          "cognito-idp:AdminGetUser",
          "cognito-idp:AdminDisableUser",
          "cognito-idp:AdminEnableUser"
        ]
        Resource = [
          "${var.COGNITO_POOL_ARN}"
        ]
      },
      {
        Sid = "DynamoDBTablePermissions"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ]
        Resource = [
          "${var.USER_TABLE_ARN}"
        ]
      }
    ]
  })
}

# -------------------------------------------------
# ROLE FOR MY MVP LAMBDA (keeping existing policy for now)
#--------------------------------------------------
resource "aws_iam_role" "my_mvp" {
   name = "my_mvp-lambda-role-${var.RESOURCE_PREFIX}"
   assume_role_policy = jsonencode({
     "Version" : "2012-10-17",
     "Statement" : [
       {
         "Action" : "sts:AssumeRole",
         "Principal" : {
           "Service" : "lambda.amazonaws.com"
         },
         "Effect" : "Allow",
         "Sid" : ""
       }
     ]
   })
 }
 

# update this policy as you add more permissions to your lambda function
resource "aws_iam_role_policy" "my_mvp" {
  name = "my_mvp-policy-${var.RESOURCE_PREFIX}"
  role = aws_iam_role.my_mvp.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "CloudWatchLogsPermissions"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = [
          "${aws_lambda_function.my_mvp.arn}",
          "${aws_lambda_function.my_mvp.arn}:*"
        ]
      },
      {
        Sid = "CognitoGetUserPermissions"
        Effect = "Allow"
        Action = [
          "cognito-idp:GetUser"
        ]
        Resource = [
          "${var.COGNITO_POOL_ARN}"
        ]
      }
    ]
  })
}