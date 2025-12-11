# Day 15: VPC Peering with Terraform

## Introduction

Today, we're diving into one of the most powerful networking concepts in AWS: **VPC Peering**. This tutorial will guide you through creating a complete, production-ready setup that connects two VPCs across different AWS regions, enabling seamless communication between resources in geographically distributed environments.

## What is VPC Peering?

VPC Peering is a networking connection between two Virtual Private Clouds that enables you to route traffic between them using private IP addresses. When implemented across regions, it becomes an invaluable tool for:

- **Disaster Recovery**: Distribute workloads across regions for high availability
- **Low Latency Access**: Route traffic directly between regions without internet gateways
- **Data Replication**: Securely replicate data between regional databases
- **Global Applications**: Build truly global applications with regional presence

## Architecture Overview

Our infrastructure will consist of:

- **Primary VPC** in `us-east-1` (10.0.0.0/16)
- **Secondary VPC** in `us-west-1` (10.1.0.0/16)
- EC2 instances in both VPCs running Apache web servers
- Bi-directional VPC peering connection
- Security groups configured for cross-region communication
- Complete networking stack (subnets, route tables, internet gateways)

## Step 1: Multi-Region Provider Configuration

The foundation of multi-region deployment lies in configuring multiple AWS provider aliases:

```hcl
terraform {
  required_providers {
    aws = {
        version = "~>6.0"
    }
  }
}

provider "aws" {
  alias = "primary"
  region = "us-east-1"
}

provider "aws" {
  alias = "secondary"
  region = "us-west-1"
}
```

**Key Takeaway**: Using provider aliases allows you to manage resources in multiple regions from a single Terraform configuration. Each resource references its target region using the `provider` argument.

## Step 2: Defining Variables

We define our network configuration using variables for flexibility:

```hcl
variable "primary_region" {
    type = string
    default = "us-east-1"
}

variable "secondary_region" {
    type = string
    default = "us-west-1"
}

variable "primary_vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "secondary_vpc_cidr" {
    type = string
    default = "10.1.0.0/16"
}

variable "primary_sn_cidr" {
    type = string
    default = "10.0.14.0/24"
}

variable "secondary_sn_cidr" {
    type = string
    default = "10.1.12.0/24"
}
```

**Pro Tip**: Non-overlapping CIDR blocks are crucial for VPC peering. Our primary (10.0.x.x) and secondary (10.1.x.x) ranges ensure no conflicts.

## Step 3: Data Sources for Dynamic Configuration

We use data sources to fetch the latest Ubuntu AMIs and available availability zones:

```hcl
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
```

**Why Data Sources?** Instead of hardcoding AMI IDs (which vary by region), we dynamically query for the latest Ubuntu 22.04 image in each region.

## Step 4: Creating VPCs in Multiple Regions

```hcl
// Primary VPC
resource "aws_vpc" "primary_vpc" {
  provider   = aws.primary
  cidr_block = var.primary_vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "VPC"
    type = "Primary"
  }
}

// Secondary VPC
resource "aws_vpc" "secondary_vpc" {
  provider         = aws.secondary
  cidr_block       = var.secondary_vpc_cidr
  instance_tenancy = "default"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "VPC"
    type = "Secondary"
  }
}
```

**Important**: Both VPCs have DNS support enabled, which is essential for resources within the VPC to resolve domain names.

## Step 5: Network Infrastructure

### Subnets

```hcl
// Subnet in Primary VPC
resource "aws_subnet" "primary_sn" {
  provider                = aws.primary
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = var.primary_sn_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.primary.names[0]

  tags = {
    Name = "Primary subnet"
  }
}

// Subnet in Secondary VPC
resource "aws_subnet" "secondary_sn" {
  provider                = aws.secondary
  vpc_id                  = aws_vpc.secondary_vpc.id
  cidr_block              = var.secondary_sn_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.secondary.names[0]

  tags = {
    Name = "Secondary subnet"
  }
}
```

### Internet Gateways

```hcl
// IGW for primary VPC
resource "aws_internet_gateway" "primary_igw" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary_vpc.id

  tags = {
    Name = "Primary IGW"
  }
}

// IGW for secondary VPC
resource "aws_internet_gateway" "secondary_igw" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary_vpc.id

  tags = {
    Name = "Secondary IGW"
  }
}
```

### Route Tables

```hcl
// Route table for primary VPC
resource "aws_route_table" "primary_rt" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary_igw.id
  }

  tags = {
    Name = "Primary VPC Route Table"
  }
}

// Route table for secondary VPC
resource "aws_route_table" "secondary_rt" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secondary_igw.id
  }

  tags = {
    Name = "Secondary VPC Route Table"
  }
}
```

## Step 6: The Heart of It - VPC Peering

This is where the magic happens! Creating a cross-region VPC peering connection involves two steps:

### 1. Creating the Peering Connection (Requester)

```hcl
resource "aws_vpc_peering_connection" "primary_to_secondary" {
  provider    = aws.primary
  vpc_id      = aws_vpc.primary_vpc.id
  peer_vpc_id = aws_vpc.secondary_vpc.id
  peer_region = var.secondary_region
  auto_accept = false

  tags = {
    Name = "Primary to secondary peering"
    Side = "Requestor"
  }
}
```

### 2. Accepting the Peering Connection (Acceptor)

```hcl
resource "aws_vpc_peering_connection_accepter" "secondary_vpc_accepter" {
  provider                  = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}
```

**Critical Note**: For cross-region peering, you must set `auto_accept = false` on the requester and use the `aws_vpc_peering_connection_accepter` resource in the target region.

### 3. Updating Route Tables

```hcl
// Route from primary to secondary
resource "aws_route" "primary_to_secondary" {
  provider                  = aws.primary
  route_table_id            = aws_route_table.primary_rt.id
  destination_cidr_block    = aws_vpc.secondary_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id

  depends_on = [aws_vpc_peering_connection_accepter.secondary_vpc_accepter]
}

// Route from secondary to primary
resource "aws_route" "secondary_to_primary" {
  provider                  = aws.secondary
  route_table_id            = aws_route_table.secondary_rt.id
  destination_cidr_block    = aws_vpc.primary_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id

  depends_on = [aws_vpc_peering_connection_accepter.secondary_vpc_accepter]
}
```

**Essential**: The `depends_on` ensures routes are only created after the peering connection is accepted.

## Step 7: Security Groups for Cross-Region Traffic

Security groups control the traffic flow between our regions:

```hcl
// Primary VPC Security Group
resource "aws_security_group" "primary_sg" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow traffic from secondary vpc"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  ingress {
    description = "allow icmp from secondary vpc"
    from_port   = -1
    to_port     = -1
    cidr_blocks = [var.secondary_vpc_cidr]
    protocol    = "icmp"
  }

  egress {
    description = "allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }

  tags = {
    Name = "Primary SG"
  }
}

// Secondary VPC Security Group
resource "aws_security_group" "secondary_sg" {
  provider = aws.secondary
  vpc_id = aws_vpc.secondary_vpc.id

  ingress {
    description = "allow ssh from anywhere"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow all traffic from primary vpc"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  ingress {
    description = "allow ICMP from primary"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  egress {
    description = "allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

**Security Best Practice**: Notice how we allow ICMP (ping) between VPCs for connectivity testing and all TCP traffic between the VPC CIDR ranges.

## Step 8: EC2 Instances with User Data

### Local Values for User Data

```hcl
locals {
  primary_user_data = <<-EOF
    #!/bin/bash
    # Update packages
    apt-get update -y

    # Install Apache
    apt-get install apache2 -y

    # Start Apache
    systemctl start apache2
    systemctl enable apache2

    # Create a sample HTML page
    echo "<h1>Hello from Terraform EC2 Local Variable!</h1>" > /var/www/html/index.html
  EOF

   secondary_user_data = <<-EOF
    #!/bin/bash
    # Update packages
    apt-get update -y

    # Install Apache
    apt-get install apache2 -y

    # Start Apache
    systemctl start apache2
    systemctl enable apache2

    # Create a sample HTML page
    echo "<h1>Hello from Terraform EC2 Local Variable!</h1>" > /var/www/html/index.html
  EOF
}
```

### EC2 Instances

```hcl
// EC2 instance in primary region
resource "aws_instance" "primary_instance" {
  provider      = aws.primary
  ami           = data.aws_ami.primary_ami.id
  instance_type = "t3.micro"
  count         = 1
  subnet_id     = aws_subnet.primary_sn.id
  key_name      = var.primary_key_pair
  security_groups = [ aws_security_group.primary_sg.id ]

  user_data = local.primary_user_data

  tags = {
    Name = "Primary Instance"
  }
}

// EC2 instance in secondary region
resource "aws_instance" "secondary_instance" {
  provider      = aws.secondary
  ami           = data.aws_ami.secondary_ami.id
  count         = 1
  instance_type = "t3.micro"
  key_name      = var.secondary_key_pair
  subnet_id     = aws_subnet.secondary_sn.id
  security_groups = [aws_security_group.secondary_sg.id]

  user_data = local.secondary_user_data

  tags = {
    Name = "Secondary Instance"
  }
}
```

## Deployment Steps

### 1. Initialize Terraform

```bash
terraform init
```

This downloads the AWS provider and initializes the backend.

### 2. Review the Execution Plan

```bash
terraform plan
```

This shows you exactly what resources Terraform will create across both regions.

### 3. Apply the Configuration

```bash
terraform apply
```

Type `yes` when prompted. Terraform will create approximately 20+ resources across two AWS regions!

![alt text](<Screenshot (1).png>)
![alt text](<Screenshot (2).png>)
![alt text](<Screenshot (5).png>)
![alt text](<Screenshot (7).png>)

### 4. Verify the Deployment

After successful deployment, you can:

1. **Test connectivity via SSH**: Connect to instances in both regions
2. **Test VPC peering**: Ping the private IP of one instance from the other
3. **Test web server**: Access Apache on both instances via their public IPs

## Testing Cross-Region Connectivity

Once deployed, SSH into the primary instance and try pinging the secondary instance's private IP:

```bash
# From primary instance
ping <secondary-instance-private-ip>
```

You should see successful responses, proving the VPC peering is working!



To avoid ongoing charges, destroy the infrastructure when done:

```bash
terraform destroy
```


## Conclusion

Congratulations! You've successfully built a multi-region infrastructure with VPC peering using Terraform. This architecture pattern is foundational for enterprise-grade AWS deployments requiring high availability, disaster recovery, and global reach.

The power of Infrastructure as Code truly shines when managing complex, multi-region setups like this. What would take hours of manual clicking in the AWS console is now reproducible, version-controlled, and automated!

## Next Steps

- Experiment with adding more subnets and availability zones
- Implement Transit Gateway for hub-and-spoke topology
- Add VPC Flow Logs for network monitoring
- Configure AWS PrivateLink for service-to-service communication
- Implement cross-region load balancing

