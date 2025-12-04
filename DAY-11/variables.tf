variable "project_name" {
    default = "Project ALPHA Resource"
  
}

variable "org_tags" {
  type = map(string)
  default = {
    "org" = "haschicorp"
    "project" = "automation"
  }
}

variable "default_tags" {
    type = map(string)
    default = {
      "env" = "dev"
      "name" = "env_tags"
    }
  
}

variable "inconsistent_bucket_name" {
    type = string
    default = "My.Project_ALPHA.Bucket."
  
}

variable "ports" {
    type = string
    default = "80,443,8080"
  
}

variable "environment" {
    type = string
    default = "development"
  
}

variable "env_instances" {
    type = map(string)
    default = {
      "dev" = "t2.medium"
      "stage" = "t2.small"  
      "prod" = "t2.large"
    }
  
}