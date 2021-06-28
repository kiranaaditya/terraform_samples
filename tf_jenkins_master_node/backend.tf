terraform {
  required_version = ">=0.12.0"
  backend "s3" {
    region  = "us-east-1"
    profile = "default"
    key     = "terraformedurekalearningstatefile.tfstate"
    bucket  = "terraformstatefiles1991"
  }
}