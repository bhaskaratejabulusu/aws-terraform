
# Define environment variable
variable "environment" {
    type = string
    description = "The environment for the resources"
    default = "dev"
}

# Username variable
variable "username" {
     description = "The username for resource naming"
     default = "bhaskaratejabulusu"
}

# Region
variable "region" {
    description = "Region for s3 bucket"
    type = string
    default = "us-east-1"
}

# Instance Count for ec2
variable "instance_count" {
    type = number
    description = "Number of EC2 instances to create"
    default = 1
}

# Configuration for ec2 instance
variable "monitoring_enabled" {
    type = bool
    default = true
}

variable "associate_public_ip" {
    type = bool
    default = true
}

# CIDR block
variable "cidr_block" {
    type = list(string)
    default = [ "10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12" ]
}

# Allowed VM Types
variable "allowed_vm_types" {
    type = list(string)
    default = [ "t2.micro", "t2.small", "t3.micro", "t3.small" ]
}

# Allowed regions
variable "allowed_region" {
    type = set(string)
    default = [ "us-east-1", "us-west-2", "eu-west-1" ]
  
}

# tags variable
variable "tags" {
    type = map(string)
    default = {
        Environment = "dev", 
        Name = "dev-Instance", 
        created_by = "terraform"
         Compliance = "soc2"
    }
  
}


variable "config" {
    type = object({
      region = string
      monitoring = bool
      instance_count = number
    })
    default = {
      region = "us-east-1"
      monitoring = true
      instance_count = 1
    }
}

# ingress values
variable "ingress_values" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}





