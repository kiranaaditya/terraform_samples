variable "project_name" {
  type    = string
  default = "jenkins"
}

variable "env_name" {
  type    = string
  default = "dev"
}

variable "author_name" {
  type    = string
  default = "kiran"
}


variable "profile" {
  type    = string
  default = "default"
}

variable "region-jenkins" {
  type    = string
  default = "us-east-1"
}

variable "instance-type-master" {
  type    = string
  default = "t2.large"
}

variable "instance-type-slave" {
  type    = string
  default = "t2.small"
}