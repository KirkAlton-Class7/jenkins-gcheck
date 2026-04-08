data "aws_iam_policy_document" "public_read_objects" {

  # ------------------------------------------------------------
  # Pipeline Artifacts - Public Read
  # ------------------------------------------------------------
  statement {
    sid    = "AllowPublicReadPipeline"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:GetObject"]

    resources = [
      "${aws_s3_bucket.frontend.arn}/pipeline/*"
    ]
  }

  # ------------------------------------------------------------
  # Audit Artifacts - Public Read
  # ------------------------------------------------------------
  statement {
    sid    = "AllowPublicReadAudit"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:GetObject"]

    resources = [
      "${aws_s3_bucket.frontend.arn}/audit/*"
    ]
  }
}