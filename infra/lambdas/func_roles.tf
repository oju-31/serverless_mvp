# ---------------------------------------
 
# ---------------------------------------
# GENERATE PROMPTS ROLE 
#----------------------------------------
resource "aws_iam_role" "generate_prompts" {
   name = "generate-prompts-lambda-role-${var.RESOURCE_PREFIX}"
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
# SEND_PROMPTS ROLE
#----------------------------------------
resource "aws_iam_role" "send_prompts" {
   name = "send-prompts-lambda-role-${var.RESOURCE_PREFIX}"
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
# GET_TOKEN ROLE
#----------------------------------------
resource "aws_iam_role" "get_token" {
   name = "get-token-lambda-role-${var.RESOURCE_PREFIX}"
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
# STORE_IMAGES ROLE
#----------------------------------------
resource "aws_iam_role" "store_images" {
   name = "store_images-lambda-role-${var.RESOURCE_PREFIX}"
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
# GET_IMAGES ROLE
#----------------------------------------
resource "aws_iam_role" "get_images" {
   name = "get-images-lambda-role-${var.RESOURCE_PREFIX}"
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
# GET_ALBUMS ROLE
#----------------------------------------
resource "aws_iam_role" "get_albums" {
   name = "get-albums-lambda-role-${var.RESOURCE_PREFIX}"
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
# UPDATE_ALBUM ROLE
#----------------------------------------
resource "aws_iam_role" "update_album" {
   name = "update-album-lambda-role-${var.RESOURCE_PREFIX}"
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