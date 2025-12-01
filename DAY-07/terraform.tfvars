environment = "dev"
username = "bhaskaratejabulusu"
region = "us-east-1"
instance_count = 1
monitoring_enabled = true
associate_public_ip = true
cidr_block = [ "10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12" ]
allowed_vm_types = [ "t2.micro", "t2.small", "t3.micro", "t3.small" ]
allowed_region = [ "us-east-1", "us-west-2", "eu-west-1" ]
tags = {
    Environment = "dev", 
    Name = "dev-Instance", 
    created_by = "terraform"
}
ingress_values = [ 443, "tcp", 443 ]
config = {
  region = "us-east-1"
  monitoring = true
  instance_count = 1
}