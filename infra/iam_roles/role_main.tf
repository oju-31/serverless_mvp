################################################################################
 # LAMBDA OPEN ROLES
################################################################################

# LOGIN
resource "aws_iam_role" "lambda_login" {
   name = "${var.RESOURCE_PREFIX}-lambda-login-role"
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
 