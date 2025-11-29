
#Create an S3 Bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "${local.bucket_name}-bucket-${var.environment}"

  tags = {
    Name        = "My S3 bucket"
    Environment = var.environment
  }
}

# Create an ec2 instance
resource "aws_instance" "ec2_instance" {
  ami = "ami-0fa3fe0fa7920f68e"
  instance_type = "t3.micro"

  tags = {
    Name = "My EC2 Instance"
    Environment = var.environment
  }
}


# Create a VPC
resource "aws_default_vpc" "vpc" {
  tags = {
    Name = "My VPC"
    Environment = var.environment
  }
}

# Create output variables
output "vpc_id" {
  value = aws_default_vpc.vpc.id
}

output "s3_bucket_id" {
    value = aws_s3_bucket.bucket.id
}
