data "aws_availability_zones" "primary" {
    provider = aws.primary
    state = "available"

}

data "aws_availability_zones" "secondary" {
    provider = aws.secondary
    state = "available"
  
}


data "aws_ami" "primary_ami" {
    provider = aws.primary
    most_recent = true
    owners = [ "amazon" ]
    
    filter {
      name = "name"
      values = [ "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" ]
    }
}

data "aws_ami" "secondary_ami" {
    provider = aws.secondary
    most_recent = true
    owners = [ "amazon" ]
    
    filter {
      name = "name"
      values = [ "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" ]
    }
}