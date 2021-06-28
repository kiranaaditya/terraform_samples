variable "profile" {
  type    = string
  default = "default"
}

variable "region-edureka" {
  type    = string
  default = "us-east-1"
}

/* variable "instance-type-jump" {
  type    = string
  default = "t2.micro"
} */

variable "instance-type-master" {
  type    = string
  default = "t2.large"
}

variable "instance-type-slave" {
  type    = string
  default = "t2.small"
}

variable "project_name" {
  type    = string
  default = "edureka"
}