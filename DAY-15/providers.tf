terraform {
  required_providers {
    aws = {
        version = "~>6.0"
    }
  }
}

provider "aws" {
  alias = "primary"
  region = "us-east-1"
}

provider "aws" {
  alias = "secondary"
  region = "us-west-1"
}