output "datadog_logs_lambda_role" {
  value = aws_iam_role.datadog_logs_lambda_role.arn
}

output "lambda_spredirect_qualified_arn" {
  value = aws_lambda_function.datadog_logs.qualified_arn
}