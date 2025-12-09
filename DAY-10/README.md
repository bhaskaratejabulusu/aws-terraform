## #30daysofawsterraform - Day-10: Conditional Expressions , Splat Expressions and Dynamic Blocks in Terraform

**Conditional Expressions:**
Conditional expressions in Terraform allow you to choose between two values based on a condition. The syntax is `condition ? true_value : false_value`. This is useful for setting resource attributes based on variable values or other conditions.

- chose instances based on the environment (dev/prod)
- enable monitoring based on the configurations
- select different AMIs based on region

example:
```
// main.tf
resource "aws_instance" "instance" {
    ami = "ami-0fa3fe0fa7920f68e"
    region = "us-east-1"
    instance_type = var.environment == "dev" ? "t3.micro" : "t3.small"
    count = var.instance_count

    tags = var.tags  
}

// variables.tf
variable "environment" {
    type = string
    default = "dev"
}
```

**Splat Expressions:**
Splat expressions allow you to extract multiple values from a list of objects. The syntax is `resource_type.resource_name[*].attribute`. This is useful for retrieving attributes from multiple instances of a resource.

example:
```
// main.tf
resource "aws_instance" "instance" {
    ami = "ami-0fa3fe0fa7920f68e"
    region = "us-east-1"
    instance_type = var.environment == "dev" ? "t3.micro" : "t3.small"
    count = var.instance_count

    tags = var.tags  
}

// splat expression example in Terraform
output "instance_ids" {
    value = aws_instance.instance[*].id
}
```

**Dynamic Blocks:**
Dynamic blocks in Terraform allow you to generate multiple nested blocks within a resource based on a list or map variable. The syntax is `dynamic "block_name" { for_each = var.list_variable ... }`. This is useful for creating multiple similar configurations without duplicating code.


example:

```
// variables.tf

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



// main.tf

// Dynamic block example in Terraform
resource "aws_security_group" "security_group" {
    name = "sg"

    dynamic "ingress" {
        for_each = var.ingress_values
      content {
        from_port   = ingress.value.from_port
        to_port     = ingress.value.to_port
        protocol    = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
      }
    }

      egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}
```

So, by using conditional expressions, splat expressions, and dynamic blocks, you can create more flexible, reusable, and maintainable Terraform configurations.