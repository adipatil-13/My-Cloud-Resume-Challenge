variable "region_name" {
  description = "AWS region to deploy resources"
  type        = string
  default = "us-east-1"
}

variable "bucket_name" {
  description = "Name of S3 bucket"
  type        = string
}

variable "lambda_name" {
  description = "The name of the lambda function"
  type        = string
}

variable "lambda_initialize_dynamodb_name" {
  description = "The name of the lambda function that initializes the dynamodb table"
  type        = string
}

variable "lambda_reset_name" {
  description = "Name of lambda function that resets counter"
  type        = string
}


variable "dynamodb_name" {
  description = "Name of the dynamodb table"
  type        = string
}

variable "lambda_runtime" {
  description = "Lambda runtime environment"
  type        = string
}

variable "state_name" {
  description = "Name of the terraform state file"
  type        = string
}



variable "cloudflare_api_token" {
  description = "API token for Cloudflare"
  type        = string
  sensitive   = true
}

variable "alternate_domain_names" {
  description = "List of alternate domain names for the CloudFront distribution"
  type        = list(string)
}

variable "domain_name" {
  description = "Custom domain name"
  type        = string
}

variable "sub_domain_name" {
  description = "Custom sub domain name"
  type        = string
}