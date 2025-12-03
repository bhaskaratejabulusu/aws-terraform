// Conditional expression example in Terraform
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