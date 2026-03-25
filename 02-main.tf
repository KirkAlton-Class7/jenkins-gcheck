# S3 Bucket -Frontend
resource "aws_s3_bucket" "frontend" {
  bucket_prefix = "jenkins-gcheck-bucket-"
  force_destroy = true
  

  tags = {
    Name = "Jenkins G-Check Bucket"
  }
}

# S3 Object - Repo Links
resource "aws_s3_object" "repo_links" {
  bucket = aws_s3_bucket.frontend.bucket

  key    = "repo_links.md"
  source = "${path.module}/path/to/repo_links.md"

  etag   = filemd5("${path.module}/s3_objects/repo_links.md")
}


# S3 Object - Repo Validation Screenshot
resource "aws_s3_object" "repo_validation" {
  bucket = aws_s3_bucket.frontend.bucket

  key    = "repo_links.md"
  source = "${path.module}/path/to/repo_validation.png"

  etag   = filemd5("${path.module}/s3_objects/repo_validation.png")
}