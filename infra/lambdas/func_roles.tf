# ---------------------------------------
# LOGIN ROLE 
#----------------------------------------
resource "aws_iam_role" "login" {
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
 
# ---------------------------------------
# GENERATE PROMPTS ROLE 
#----------------------------------------
resource "aws_iam_role" "generate_prompts" {
   name = "${var.RESOURCE_PREFIX}-lambda-generate-prompts-role"
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
 