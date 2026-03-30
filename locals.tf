# -----------------------------------------------------
# LOCALS 
# -----------------------------------------------------
locals {
  s3_objects = {

    # ---------------------------------------------------
    # Stage 1 - Initial Pipeline Deployment Artifacts
    # ---------------------------------------------------

    # Repo links
    "repo_links.md" = {
      content_type = "text/markdown"
      stage        = "pipeline"
    }

    # Webhook setup
    "github-webhook-configuration.png" = {
      content_type = "image/png"
      stage        = "pipeline"
    }

    "jenkins-webhook-trigger-enabled.png" = {
      content_type = "image/png"
      stage        = "pipeline"
    }

    # Repo validation
    "repo_validation.png" = {
      content_type = "image/png"
      stage        = "pipeline"
    }


    # ----------------------------------------------------
    # Stage 2 - Audit & Verification Artifacts
    # ----------------------------------------------------

    # Proof of pipeline success
    "jenkins-terraform-deployment-success.png" = {
      content_type = "image/png"
      stage        = "audit"
    }

    "jenkins-pipeline-execution-console.png" = {
      content_type = "image/png"
      stage        = "audit"
    }

    # CLI verification of pipeline execution
    "console-output.txt" = {
      content_type = "text/plain"
      stage        = "audit"
    }

    # S3 objects verification
    "aws-s3-bucket-root.png" = {
      content_type = "image/png"
      stage        = "audit"
    }

    "aws-s3-pipeline-artifacts-list.png" = {
      content_type = "image/png"
      stage        = "audit"
    }

    "aws-s3-audit-artificats-list.png" = {
      content_type = "image/png"
      stage        = "audit"
    }

    "s3-audit-screenshot.png" = {
      content_type = "image/png"
      stage        = "audit"
    }

    # CLI verification of S3 objects
    "s3-audit.json" = {
      content_type = "application/json"
      stage        = "audit"
    }
  }
}