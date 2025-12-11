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


// Secondary vpc
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
    Name = "Primary subnet"
  }
}

// crate igw for primary vpc
resource "aws_internet_gateway" "primary_igw" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary_vpc.id

  tags = {
    Name = "Primary IGW"
  }

}

// create igw for secondary vpc
resource "aws_internet_gateway" "secondary_igw" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary_vpc.id

  tags = {
    Name = "Secondary IGW"
  }

}


// create route table for primary vpc
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



// create route table for secondary vpc
resource "aws_route_table" "secondary_rt" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secondary_igw.id
  }

  tags = {
    Name = "Primary VPC Route Table"
  }
}

// associate primary route table to subnet
resource "aws_route_table_association" "primary_rt_assoc" {
  provider       = aws.primary
  route_table_id = aws_route_table.primary_rt.id
  subnet_id      = aws_subnet.primary_sn.id

}

// associate secondary route table to subnet
resource "aws_route_table_association" "secondary_rt_assoc" {
  provider       = aws.secondary
  route_table_id = aws_route_table.secondary_rt.id
  subnet_id      = aws_subnet.secondary_sn.id
}


// create a vpc peering connection from primary to secondary
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

// accept the peering connection from primary (Acceptor = secondary)
resource "aws_vpc_peering_connection_accepter" "secondary_vpc_accepter" {
  provider                  = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

// add route from primary vpc to secondary vpc
resource "aws_route" "primary_to_secondary" {
  provider                  = aws.primary
  route_table_id            = aws_route_table.primary_rt.id
  destination_cidr_block    = aws_vpc.secondary_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id

  depends_on = [aws_vpc_peering_connection_accepter.secondary_vpc_accepter]

}

// add route from secondary vpc to primary vpc
resource "aws_route" "secondary_to_primary" {
  provider                  = aws.secondary
  route_table_id            = aws_route_table.secondary_rt.id
  destination_cidr_block    = aws_vpc.primary_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id

  depends_on = [aws_vpc_peering_connection_accepter.secondary_vpc_accepter]

}

// create an ec2 instance in primary subnect
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


// create an ec2 instance in secondary subnect
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

// create security group for primary vpc
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

// create security group for secondary vpc
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










