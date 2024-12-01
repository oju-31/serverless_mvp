# --------------------------------------
    ]
  })
}

# -------------------------------------------------
# GENERATE PROMPTS POLICY
#--------------------------------------------------
resource "aws_iam_role_policy" "generate_prompts" {
  name = "${var.RESOURCE_PREFIX}-lambda-generate-prompts-policy"
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
  name = "${var.RESOURCE_PREFIX}-lambda-send_prompts-policy"
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
  name = "${var.RESOURCE_PREFIX}-lambda-get_token-policy"
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
  name = "${var.RESOURCE_PREFIX}-lambda-store_images-policy"
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
  name = "${var.RESOURCE_PREFIX}-lambda-get_images-policy"
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
  name = "${var.RESOURCE_PREFIX}-lambda-get_albums-policy"
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
  name = "${var.RESOURCE_PREFIX}-lambda-update_album-policy"
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