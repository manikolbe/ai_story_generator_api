output "api_endpoint" {
  description = "API Gateway endpoint URL"
  value       = aws_apigatewayv2_api.api.api_endpoint
}

output "lambda_arn" {
  description = "Story generator lambda function name"
  value       = aws_lambda_function.story_generator_lambda.function_name
}
