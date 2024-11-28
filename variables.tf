variable "ENV" {
    type = string
}

# variable "ROUTE53_HOSTED_ZONE_NAME" {
#     type = string
# }

# variable "WEBAPP_DNS" {
#     type = string
# }

variable "COGNITO_USER_POOL_ID" {
    type = string
}

variable "COGNITO_CLIENT_ID" {
    type = string
}

variable "GITHUB_ACTIONS_USER_ARN" {
    type = string
}

variable "AWS_REGION" {
    type = string
    default = "us-east-1"
}
