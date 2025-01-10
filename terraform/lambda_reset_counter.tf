# Zip Lambda function code
data "archive_file" "zip_reset_counter" {
  type        = "zip"
  source_file = "../backend/reset_count.py"
  output_path = "../terraform/reset_counter.zip"
}


# Define the Lambda function
resource "aws_lambda_function" "reset_lambda" {
  function_name = var.lambda_reset_name
  filename      = data.archive_file.zip_reset_counter.output_path
  handler       = "reset_counter.lambda_handler"
  source_code_hash = data.archive_file.zip_reset_counter.output_base64sha256
  runtime       = var.lambda_runtime
  role          = aws_iam_role.lambda_role.arn

  # Ensure the Lambda function is created after the zip file
  depends_on = [
	aws_iam_role.lambda_role,
	data.archive_file.zip_reset_counter
  ]
}

# Enable function URL and CORS
resource "aws_lambda_function_url" "reset_lambda_url" {
  function_name      = aws_lambda_function.reset_lambda.function_name
  authorization_type = "NONE"

  cors {
  allow_origins = ["*"]
  allow_methods = ["*"]                   # Include all methods
  allow_headers = ["Content-Type"]        # Include Content-Type
  }

  # Ensure the function URL is created after the reset_lambda function
  depends_on = [aws_lambda_function.reset_lambda]
}