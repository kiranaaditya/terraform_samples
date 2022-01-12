provider "aws" {
  profile = data.terraform_remote_state.backend_resources.outputs.profile
  region  = data.terraform_remote_state.backend_resources.outputs.region
  alias   = "kiran"
}