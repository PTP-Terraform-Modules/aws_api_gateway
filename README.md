## aws_api_gateway
Terraform module for creating an API Gateway with Lambda Proxy integration.

## Input variables:
* `api_gw_name` - The API Gateway Name
* `integration_type` - The API Integration Type. Must be AWS_PROXY for Lambda proxy integration.
* `http_method` - The API HTTP Method. Recommend using ANY to integrate with the Lambda.
* `rest_api_stage_name` - The API Deployment Stage
* `lambda_function_name` - The Lambda function name
* `lambda_function_arn` - The ARN of the Lambda Function
* `api_gw_region` - The AWS region for the API Gateway
* `api_gw_account_id` - The AWS Account ID for the API Gateway

## Outputs:
* `invoke_url` - Returns the URL to invoke the API pointing to the stage.

## Example:
```hcl
module "aws_api_gateway" {
  source               = "github.com/PTP-Terraform-Modules/aws_api_gateway"
  api_gw_name          = "api_gateway_module_test"
  integration_type     = "AWS_PROXY"
  http_method          = "ANY"
  rest_api_stage_name  = "test"
  lambda_function_name = aws_lambda_function.example.function_name
  lambda_function_arn  = aws_lambda_function.example.arn
  api_gw_region        = "us-east-2"
  api_gw_account_id    = data.aws_caller_identity.current.account_id
}
```