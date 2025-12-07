data "aws_ami" "ubuntu" {

    most_recent = true
    owners      = [ "amazon" ] # Canonical

    filter {
      name = "name"
      values = [ "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" ]
    }

  
}

data "aws_vpc" "default_vpc" {
    filter {
      name = "tag:Name"
      values = ["shared-network-vpc"]
    }
  
}

data "aws_subnet" "default_subnet" {
    filter {
      name = "tag:Name"
      values = ["shared-primary-subnet"]
    }
  vpc_id = data.aws_vpc.default_vpc.id
}

resource "aws_instance" "aws_instance" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t3.micro"
    subnet_id = data.aws_subnet.default_subnet.id
    tags = {
      Name = "Day-13-Instance"
      CreatedBy = "Terraform"
    }
}