# ----------------------------------------------------------------
# BACKEND — Terraform Backend Configuration (S3)
# ----------------------------------------------------------------
# Uses platform-managed bootstrap infrastructure (S3 backend and lockfile).

terraform {
  backend "s3" {
    bucket       = "kirkdevsecops-terraform-state"
    key          = "jenkins/dev/jenkins_gcheck/terraform.tfstate"
    region       = "us-west-2"
    use_lockfile = false
    encrypt      = true
  }
}