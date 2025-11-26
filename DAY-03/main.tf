
#Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


#Create an S3 Bucket
resource "aws_s3_bucket" "example" {
  bucket = "bhaskaratejabulusu-aws-terraform-bucket"

  tags = {
    Name        = "My bucket Modified"
    Environment = "Dev"
  }
} 