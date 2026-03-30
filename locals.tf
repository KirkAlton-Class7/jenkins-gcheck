# -----------------------------------------------------
# LOCALS 
# -----------------------------------------------------
locals {
  s3_objects = {

    # ---------------------------------------------------
    # Stage 1 - Initial Pipeline Deployment Artifacts
    # ---------------------------------------------------
    "repo_links.md" = {
      content_type = "text/markdown"
      stage        = "pipeline"
    }

    "repo_validation.png" = {
      content_type = "image/png"
      stage        = "pipeline"
    }

    "github-webhook-configuration.png" = {
      content_type = "image/png"
      stage        = "pipeline"
    }

    "jenkins-webhook-trigger-enabled.png" = {
      content_type = "image/png"
      stage        = "pipeline"
    }


    # ----------------------------------------------------
    # Stage 2 - Audit & Verification Artifacts
    # ----------------------------------------------------
    "s3-audit.json" = {
      content_type = "application/json"
      stage        = "audit"
    }

    "aws-s3-bucket-deployment-result.png" = {
      content_type = "image/png"
      stage        = "audit"
    }

    "console-output.txt" = {
      content_type = "text/plain"
      stage        = "audit"
    }

    "jenkins-terraform-deployment-success.png" = {
      content_type = "image/png"
      stage        = "audit"
    }

    "s3-audit-screenshot.png" = {
      content_type = "image/png"
      stage        = "audit"
    }

    "jenkins-pipeline-execution-console.png" = {
      content_type = "image/png"
      stage        = "audit"
    }
  }
}