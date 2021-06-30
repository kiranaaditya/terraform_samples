locals {
  common_tags = {
    AuthorName  = var.author_name
    ProjectName = var.project_name
    Environment = var.env_name
  }
}