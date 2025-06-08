# --------------------------------------------------
# SEWING GUIDES ROLE 
#---------------------------------------------------
resource "aws_iam_role" "sewing_guides" {
   name = "sewing_guides-lambda-role-${var.RESOURCE_PREFIX}"
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
 
#  inline policy
resource "aws_iam_role_policy" "sewing_guides" {
  name = "sewing_guides-policy-${var.RESOURCE_PREFIX}"
  role = aws_iam_role.sewing_guides.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = "*",
        Resource = [
          "*"
        ]
      }
    ]
  })
}


# -------------------------------------------------
# STORE MNGT ROLE 
#--------------------------------------------------
resource "aws_iam_role" "store_mngt" {
   name = "store_mngt-lambda-role-${var.RESOURCE_PREFIX}"
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
 
#  inline policy
resource "aws_iam_role_policy" "store_mngt" {
  name = "store_mngt-policy-${var.RESOURCE_PREFIX}"
  role = aws_iam_role.store_mngt.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = "*",
        Resource = [
          "*"
        ]
      }
    ]
  })
}

# -------------------------------------------------
# STYLE GENERATIONS ROLE 
#--------------------------------------------------
resource "aws_iam_role" "style_generations" {
   name = "style_generations-lambda-role-${var.RESOURCE_PREFIX}"
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
 
#  inline policy
resource "aws_iam_role_policy" "style_generations" {
  name = "style_generations-policy-${var.RESOURCE_PREFIX}"
  role = aws_iam_role.style_generations.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = "*",
        Resource = [
          "*"
        ]
      }
    ]
  })
}


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
 
#  inline policy
resource "aws_iam_role_policy" "user_mngt" {
  name = "user_mngt-policy-${var.RESOURCE_PREFIX}"
  role = aws_iam_role.user_mngt.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = "*",
        Resource = [
          "*"
        ]
      }
    ]
  })
}
