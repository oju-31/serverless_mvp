# ---------------------------------------
 
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
 

# ---------------------------------------
# SEND_PROMPTS ROLE
#----------------------------------------
resource "aws_iam_role" "send_prompts" {
   name = "${var.RESOURCE_PREFIX}-lambda-send_prompts-role"
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
   name = "${var.RESOURCE_PREFIX}-lambda-get_token-role"
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
   name = "${var.RESOURCE_PREFIX}-lambda-store_images-role"
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
   name = "${var.RESOURCE_PREFIX}-lambda-get_images-role"
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
   name = "${var.RESOURCE_PREFIX}-lambda-get_albums-role"
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
   name = "${var.RESOURCE_PREFIX}-lambda-update_album-role"
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