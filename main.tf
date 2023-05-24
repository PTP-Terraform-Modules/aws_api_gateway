resource "aws_api_gateway_rest_api" "rest_api" {
  name = var.api_gw_name
  binary_media_types = [
    "*/*"
  ]
  minimum_compression_size = 0

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "rest_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "rest_api_root_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  http_method   = var.http_method
  authorization = "NONE"
}

resource "aws_api_gateway_method" "rest_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.rest_api_resource.id
  http_method   = var.http_method
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "rest_api_root_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_rest_api.rest_api.root_resource_id
  http_method             = aws_api_gateway_method.rest_api_root_method.http_method
  type                    = var.integration_type
  uri                     = "arn:aws:apigateway:${var.api_gw_region}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_integration" "rest_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.rest_api_resource.id
  http_method             = aws_api_gateway_method.rest_api_method.http_method
  type                    = var.integration_type
  uri                     = "arn:aws:apigateway:${var.api_gw_region}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}/invocations"
  integration_http_method = "POST"
  cache_key_parameters    = ["method.request.path.proxy"]
}

resource "aws_lambda_permission" "api_gateway_lambda_root" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.api_gw_region}:${var.api_gw_account_id}:${aws_api_gateway_rest_api.rest_api.id}/*/*/"
}

resource "aws_lambda_permission" "api_gateway_lambda_greedy" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.api_gw_region}:${var.api_gw_account_id}:${aws_api_gateway_rest_api.rest_api.id}/*/*/*"
}

resource "aws_api_gateway_deployment" "rest_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.rest_api_resource.id,
      aws_api_gateway_method.rest_api_method.id,
      aws_api_gateway_integration.rest_api_integration.id
    ]))
  }
}

resource "aws_api_gateway_stage" "rest_api_stage" {
  deployment_id = aws_api_gateway_deployment.rest_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = var.rest_api_stage_name
}