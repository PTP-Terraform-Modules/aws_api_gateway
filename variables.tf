variable "api_gw_name" {
  description = "The API Gateway Name"
  type        = string
}

variable "integration_type" {
  description = "The API Integration Type"
  type        = string
}

variable "http_method" {
  description = "The API HTTP Method"
  type        = string
}

variable "rest_api_stage_name" {
  description = "The API Deployment Stage"
  type        = string
}

variable "lambda_function_name" {
  description = "The Lambda function name"
  type        = string
}

variable "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  type        = string
}

variable "api_gw_region" {
  description = "The AWS region for the API Gateway"
  type        = string
}

variable "api_gw_account_id" {
  description = "The AWS Account ID for the API Gateway"
  type        = string
}