resource "aws_iam_role" "datadog_logs_lambda_role" {
  name = "datadog-logs-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# 最小限のポリシー+パラメータストアからのGet
# cloudwatch logsから自動でログを引っ張るような場合は、追加で権限が必要です。
# https://docs.datadoghq.com/ja/integrations/amazon_web_services/?tab=allpermissions#send-aws-service-logs-to-datadog
data "aws_iam_policy_document" "datadog_logs_lambda_policy_doc" {
  statement {
    sid = "1"

    actions = [
      "s3:GetObject",
      "ssm:GetParameters",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

resource "aws_iam_role_policy" "datadog_logs_lambda_policy" {
  name   = "datadog-logs-lambda-policy"
  role   = aws_iam_role.datadog_logs_lambda_role.name
  policy = data.aws_iam_policy_document.datadog_logs_lambda_policy_doc.json
}

data "archive_file" "datadog_logs" {
  type        = "zip"
  source_dir  = "${path.module}/code/logs_monitoring"
  output_path = "lambda_datadog_logs.zip"
}

resource "aws_lambda_function" "datadog_logs" {
  filename         = data.archive_file.datadog_logs.output_path
  function_name    = "datadog_logs"
  role             = aws_iam_role.datadog_logs_lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.datadog_logs.output_base64sha256
  runtime          = "python2.7"
  publish          = true
  memory_size      = var.log_lambda_memory
  timeout          = var.log_lambda_timeout

  environment {
    variables = {
      DD_SSM_KEY = var.ssm_key_name
    }
  }
}