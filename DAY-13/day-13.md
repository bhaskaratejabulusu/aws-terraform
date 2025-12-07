## 30daysofAwsTerraform - Day 13 : Data Sources in Terraform AWS Provider

### Task : Use Data Sources in Terraform AWS Provider to fetch existing resources information.

**What are Data Sources?**
Data source in terraform refers to a way to read existing resources instead of creating new ones. Data sources lookup and use the data from things that already exist in your cloud or other services. This is useful when you want to reference information about resources that are not managed by your terraform configuration.

example: You can use data sources to fetch information about existing VPCs, subnets, AMIs, security groups, etc.

syntax:
```hcl
data "data_source_type" "data_source_name" {
  # Configuration arguments
}
```

**Filters:**
Filters are used in data sources to narrow down the results based on specific criteria. They help you to find the exact resource you are looking for by applying conditions just like search queries.

example:
```hcl
filter {
  name   = "filter_name"
  values = ["value1", "value2"]
}
```

**Example: Creating an EC2 instance by fetching the AMI ID using Data Source and Subnet ID using Data Source**

```hcl
// main.tf

# Fetch the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["amazon"] // Canonical
}

# Fetch existing VPC by Name tag
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["shared-primary-vpc"]
  }
}

# Fetch existing Subnet by Name tag within the selected VPC
data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = ["shared-primary-subnet"]
  }
    vpc_id = data.aws_vpc.selected.id
}

# Create an EC2 instance using the fetched AMI and Subnet
resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.selected.id

  tags = {
    Name = "day-13-instance"
  }
}
---
```**Output:**
```hcl

// outputs.tf
output "instance_id" {
  value = aws_instance.example.id
}
output "instance_public_ip" {
  value = aws_instance.example.public_ip
}
```

Now, the terraform configuration uses data sources to fetch the latest Ubuntu AMI and existing subnet information to create an EC2 instance.