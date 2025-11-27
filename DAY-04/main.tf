
terraform {
  backend "s3" {
    bucket = "bhaskaratejabulusu-state-files-day04"
    key = "dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true

  }
}

#Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


#Create an S3 Bucket
resource "aws_s3_bucket" "example" {
  bucket = "bhaskaratejabulusu-aws-terraform-bucket-day04"

  tags = {
    Name        = "My bucket Modified"
    Environment = "Dev"
  }
} 

