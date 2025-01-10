#s3 bucket creation

resource "aws_s3_bucket" "frontend_bucket" {
  bucket = var.bucket_name
}

resource "time_sleep" "wait_for_bucket" {
  depends_on = [aws_s3_bucket.frontend_bucket]
  create_duration = "30s"
}

resource "aws_s3_bucket_website_configuration" "frontend_bucket_website" {
  bucket = aws_s3_bucket.frontend_bucket.bucket

  index_document {
	suffix = "index.html"
  }

  error_document {
	key = "index.html"
  }
}

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.frontend_bucket.bucket
  key          = "index.html"
  source       = "${path.module}/../frontend/index.html"
  etag         = filemd5("${path.module}/../frontend/index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "styles_css" {
  bucket       = aws_s3_bucket.frontend_bucket.bucket
  key          = "css/styles.css"
  source       = "${path.module}/../frontend/css/styles.css"
  etag         = filemd5("${path.module}/../frontend/css/styles.css")
  content_type = "text/css"
}

resource "aws_s3_object" "scripts_js" {
  bucket       = aws_s3_bucket.frontend_bucket.bucket
  key          = "js/scripts.js"
  source       = "${path.module}/../frontend/js/scripts.js"
  etag         = filemd5("${path.module}/../frontend/js/script.js")
  content_type = "application/javascript"
  depends_on   = [aws_lambda_function.frontend_lambda]
}

resource "aws_s3_object" "profile_image" {
  bucket       = aws_s3_bucket.frontend_bucket.bucket
  key          = "images/profile.jpg"
  source       = "${path.module}/../frontend/images/profile.jpg"
  etag         = filemd5("${path.module}/../frontend/images/profile.jpg")
  content_type = "image/jpeg"
}

resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
	Version = "2012-10-17"
	Statement = [
	  {
		Effect = "Allow"
		Principal = "*"
		Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
		Resource = "${aws_s3_bucket.frontend_bucket.arn}/*"
	  }
	]
  })

  depends_on = [
    aws_s3_bucket.frontend_bucket,
    time_sleep.wait_for_bucket
  ]
  
}

resource "aws_s3_bucket_public_access_block" "frontend_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.frontend_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}