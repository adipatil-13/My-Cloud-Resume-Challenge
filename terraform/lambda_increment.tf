#This code will zip the .py lambda function
data "archive_file" "zip_lambda_function" {
  type        = "zip"
  source_file = "../backend/lambda_function.py"
  output_path = "../terraform/lambda_function.zip"
}


# Define the Lambda function
resource "aws_lambda_function" "frontend_lambda" {
  function_name = var.lambda_name
  filename      = data.archive_file.zip_lambda_function.output_path
  handler       = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.zip_lambda_function.output_base64sha256
  runtime       = var.lambda_runtime
  role          = aws_iam_role.lambda_role.arn

  # Ensure the Lambda function is created after the zip file
  depends_on = [
	aws_iam_role.lambda_role,
  data.archive_file.zip_lambda_function
  ]
}

# Enable function URL and CORS
resource "aws_lambda_function_url" "frontend_lambda_url" {
  function_name      = aws_lambda_function.frontend_lambda.function_name
  authorization_type = "NONE"

  cors {
	allow_origins = ["*"]
  allow_methods = ["*"]  # Include all methods
  allow_headers = ["Content-Type"]            # Include Content-Type
  }

  # Ensure the function URL is created after the frontend_lambda function
  depends_on = [aws_lambda_function.frontend_lambda]
}