terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.75"
    }
  }
  required_version = ">= 1.2.0"
}

# Create IAM Role for lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-aws_lambda_role"
  tags = {
    Project_Name = var.project_name
    Owner        = var.owner
  }
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

# IAM policy for the lambda
resource "aws_iam_policy" "iam_policy_for_lambda" {

  name        = "${var.project_name}-aws_iam_policy_for_aws_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  tags = {
    Project_Name = var.project_name
    Owner        = var.owner
  }
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
    {
            "Effect": "Allow",
            "Action": "bedrock:InvokeModel",
            "Resource": "arn:aws:bedrock:*::foundation-model/*"
    }
  ]
}
EOF
}

# Role - Policy Attachment
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

# Zipping the code, lambda wants the code as zip file
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.cwd}/../src/"
  output_path = "${path.cwd}/../build/lambda.zip"
}

# Lambda Function, in terraform ${path.module} is the current directory.
resource "aws_lambda_function" "story_generator_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.project_name}-lambda-function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "main.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256 # Automatically updates based on archive changes
  depends_on       = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  timeout          = 30
  tags = {
    Project_Name = var.project_name
    Owner        = var.owner
  }
}
