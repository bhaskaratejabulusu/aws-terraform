
#Create an S3 Bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "${local.bucket_name}-bucket-${var.environment}"
  region = var.region

  tags = {
    Name        = "My S3 bucket"
    Environment = var.environment
  }
}

# Create an ec2 instance
resource "aws_instance" "ec2_instance" {
  ami = "ami-0fa3fe0fa7920f68e"
  instance_type = var.allowed_vm_types[2]
  count = var.instance_count
  monitoring = var.config.monitoring
  associate_public_ip_address = var.associate_public_ip


  tags = var.tags
}


# Create a VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr_block[1]

  tags = {
    Name = "Default VPC"
  }
}

# Create Security Group to allow TLS traffic

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.cidr_block[1]
  from_port         = var.ingress_values[0]
  ip_protocol       = var.ingress_values[1]
  to_port           = var.ingress_values[2]
  description       = "Allow TLS inbound traffic from specific CIDR block"
}