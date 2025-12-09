terraform {
  required_providers {
    aws = {
        version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}