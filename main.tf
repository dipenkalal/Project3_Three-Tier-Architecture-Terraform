#--------------------------------------------
# Terraform Block: Required Versions and Providers
#--------------------------------------------

# This block sets the required Terraform version and the providers used in this configuration.
terraform {
  # Specify the minimum Terraform version required to run this configuration.
  required_version = ">=1.0.0"

  # Declare the required providers and their sources/versions.
  required_providers {
    # AWS provider by HashiCorp with version 5.0 or higher
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0"
    }

    # Random provider by HashiCorp with version 1.0 or higher
    random = {
      source  = "hashicorp/random"
      version = ">=1.0"
    }
  }
}

#--------------------------------------------
# Provider Block: AWS
#--------------------------------------------

# This block configures the AWS provider to use the 'us-east-2' region by default.
provider "aws" {
  region = "us-east-2" # Ohio region
}
