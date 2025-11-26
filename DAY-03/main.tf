resource "aws_s3_bucket" "example" {
  bucket = "bhaskaratejabulusu-aws-terraform-bucket"

  tags = {
    Name        = "My bucket Modified"
    Environment = "Dev"
  }
}