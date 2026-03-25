terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # Use latest version if possible
    }
  }

/*   backend "s3" {?
    bucket  = "tf-backend-4357232"                 # Name of the S3 bucket
    key     = "jenkins-test-013125.tfstate" # The name of the state file in the bucket
    region  = "us-east-1"                          # Use a variable for the region
    encrypt = true                                 # Enable server-side encryption (optional but recommended)
  } */
}

provider "aws" {
  region  = "us-west-2"
  
}

