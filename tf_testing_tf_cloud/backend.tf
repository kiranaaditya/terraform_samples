terraform {
  cloud {
    organization = "kiran-personal"
    workspaces {
      name = "testing_tf_cloud"
    }
  }
}