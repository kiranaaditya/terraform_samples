terraform {
  required_version = ">=1.1.0"
  backend "s3" {
    region  = "us-east-1"
    profile = "default"
    key     = "tfsupportingresources.tfstate"
    bucket  = "terraformstatefiles2021"
  }
}

/* terraform {
  cloud {
    organization = "kiran-personal"
    workspaces {
      name = "shared_resources"
    }
  }
} */