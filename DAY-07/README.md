## 30daysofawsterraform
## Day 7: Terraform Variable Type Constraint Tasks

The variables in terraform are classified into two types
- Based on Purpose
- Based on value (Type Constraints)

The Type constraints are again classified into three types
- Primitive --> String, Number, Bool
- Complex --> List, Set, Tuple, Map, Object
- Null and Any

Let's see one by one

**String:**
Combination of characters is known as a string. in terraform the string is enclosed between quotes
example: 
```
environment - "development"
```

example code:

**Objective:** Use the simple `string` type variables to set the AWS Provider configuration and apply a basic naming convention.

```
// variables.tf

variable "environment" {
    type = string
    description = "The environment for the resources"
    default = "dev"
}

// main.tf
resource "aws_s3_bucket" "bucket" {
  bucket = "${local.bucket_name}-bucket-${var.environment}"
  region = var.region

  tags = {
    Name        = "My S3 bucket"
    Environment = var.environment
  }
}
```

**Number:**
The number type constraint in terrraform is just a simple numeric value.
example:
count=1

example code:

**Objective:** Use the `number` constraint to define the desired quantity of a resource using Terraform’s `count` argument.

```


// variables.tf
variable "instance_count" {
    type = number
    description = "Number of EC2 instances to create"
    default = 1
}

//main.tf
resource "aws_instance" "ec2_instance" {
  ami = "ami-0fa3fe0fa7920f68e"
  count = var.instance_count

}

```

---

**Boolean:**
The boolean constraint in terraform is defined as the value which is either true or false
example:
monitoring = true

example code:
**Objective:** Use `bool` variables to control binary configuration settings (true/false flags) for AWS resources.

```
// variables.tf
variable "monitoring_enabled" {
    type = bool
    default = true
}

variable "associate_public_ip" {
    type = bool
    default = true
}

// main.tf

# Create an ec2 instance
resource "aws_instance" "ec2_instance" {
  ami = "ami-0fa3fe0fa7920f68e"
  count = var.instance_count
  monitoring = var.config.monitoring
  associate_public_ip_address = var.associate_public_ip

}
```
---

**List:**
The list in terraform is an ordered collection of elements of same type
- duplicates are allowed
- elements in list are accessed using index
example:
regions = ["us-east-1","us-west-1","eu-west-1"]

example code:
**Objective:** Use a `list(string)` to define multiple, ordered values of the same type for sequential use.

```
// variables.tf
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

// main.tf

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

```


---
**Set:**
A set in terraform is an unordered collection of unique elements of same type.
- duplicate values are not allowed
- should be accessed using values (no index)
- tolist(): method that converts a set to list

example:
[ "us-east-1", "us-west-2", "eu-west-1" ]

example code:

**Objective:** Use a `set(string)` to define a collection of unique, unordered values, typically for validation purposes.


```
// variables.tf
# Allowed regions
variable "allowed_region" {
    type = set(string)
    default = [ "us-east-1", "us-west-2", "eu-west-1" ]
  
}

// providers.tf
provider "aws" {
  region = var.config.region
}

```

**Map:**
Map in terraform is the collection of key-value pairs.
- accessed using keys

example code:
**Objective:** Use a `map(string)` to pass dynamic key-value pairs, primarily for resource metadata and cost allocation.

```
// variables.tf
# tags variable
variable "tags" {
    type = map(string)
    default = {
        Environment = "dev", 
        Name = "dev-Instance", 
        created_by = "terraform"
    }
}

//main.tf
resource "aws_instance" "ec2_instance" {
  ami = "ami-0fa3fe0fa7920f68e"

  tags = var.tags // using map
}


```

**Tuple:**
Tuple is an ordered collection of elements where each element can be of different type
- accessed through index

example code:
**Objective:** Use a `tuple` to enforce a rigid structure where the position and type of elements are strictly defined.

```
// variables.tf
# Ingress values
variable "ingress_values" {
    type = tuple([ number, string, number ])
    default = [ 443, "tcp", 443 ]
  
}

//main.tf
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


```
---
**Object:**
Object is a collection of named attributes, where each attribute has a defined type.
- accessed via dot notation

example code:
**Objective:** Use an `object` to group multiple configuration values of different types under a single variable, improving code organization.

```
// variables.tf
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

// main.tf
resource "aws_instance" "ec2_instance" {
  ami = "ami-0fa3fe0fa7920f68e"
  count = var.config.instance_count
  monitoring = var.config.monitoring
  region = var.config.region
}

```

In this way we use the type constraints in different use cases.