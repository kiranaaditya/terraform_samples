#Provision for defining multiple providers with using "alias" parameter
provider "aws" {
  profile = var.profile
  region  = var.region-k8s-sample
  alias   = "region-k8s-sample"
}