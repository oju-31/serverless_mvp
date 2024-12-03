# -------------------------------------------------
# GENERATE PROMPTS POLICY
#--------------------------------------------------
resource "aws_iam_role_policy" "generate_prompts" {
  name = "generate-prompts-lambda-policy-${var.RESOURCE_PREFIX}"
  role = aws_iam_role.generate_prompts.id

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
# SEND_PROMPTS POLICY
#--------------------------------------------------
resource "aws_iam_role_policy" "send_prompts" {
  name = "send-prompts-lambda-policy-${var.RESOURCE_PREFIX}"
  role = aws_iam_role.send_prompts.id
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
# GET_TOKEN POLICY
#--------------------------------------------------
resource "aws_iam_role_policy" "get_token" {
  name = "get-token-lambda-policy-${var.RESOURCE_PREFIX}"
  role = aws_iam_role.get_token.id
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
# STORE_IMAGES POLICY
#--------------------------------------------------
resource "aws_iam_role_policy" "store_images" {
  name = "store-images-lambda-policy-${var.RESOURCE_PREFIX}"
  role = aws_iam_role.store_images.id
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
# GET_IMAGES POLICY
#--------------------------------------------------
resource "aws_iam_role_policy" "get_images" {
  name = "get-images-lambda-policy-${var.RESOURCE_PREFIX}"
  role = aws_iam_role.get_images.id
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
# GET_ALBUMS POLICY
#--------------------------------------------------
resource "aws_iam_role_policy" "get_albums" {
  name = "get-albums-lambda-policy-${var.RESOURCE_PREFIX}"
  role = aws_iam_role.get_albums.id
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
# UPDATE_ALBUM POLICY
#--------------------------------------------------
resource "aws_iam_role_policy" "update_album" {
  name = "update-album-lambda-policy-${var.RESOURCE_PREFIX}"
  role = aws_iam_role.update_album.id
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