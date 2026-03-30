# ----------------------------------------------------------------
# S3 Bucket - Frontend
# ----------------------------------------------------------------
resource "aws_s3_bucket" "frontend" {
  bucket_prefix = "jenkins-gcheck-bucket-"
  force_destroy = true

  tags = {
    Name = "Jenkins G-Check Bucket"
  }
}

# Public access block configuration
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# ----------------------------------------------------------------
# S3 Bucket Policy - Public Read Access
# ----------------------------------------------------------------
resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.aws_iam_policy_document.public_read_objects.json
  
  depends_on = [aws_s3_bucket_public_access_block.frontend]
}

# ----------------------------------------------------------------
# S3 Object - Upload Pipeline & Audit Artifacts
# ----------------------------------------------------------------
resource "aws_s3_object" "frontend_files" {
  for_each = local.s3_objects
  
  bucket = aws_s3_bucket.frontend.id

  # Store artifacts with stage prefix (pipeline/ or audit/)
  key = "${each.value.stage}/${each.key}"

  # Source path
  source       = "${path.module}/s3_objects/${each.key}"
  content_type = each.value.content_type

  # Compute MD5 hash of the file so Terraform can detect content changes
  etag = filemd5("${path.module}/s3_objects/${each.key}")

  tags = {
    Name        = each.key
    ContentType = each.value.content_type
    Stage       = each.value.stage
  }
}