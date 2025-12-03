
// Create before destroy to avoid downtime
resource "aws_instance" "instance" {
    ami = "ami-0f64121fa59598bf7"
    instance_type = "t3.micro"
    region = tolist(var.allowed_region)[0]

    tags = var.tags

    lifecycle {
      create_before_destroy = true
    }

}

// prevent destroy to avoid accidental deletion
resource "aws_s3_bucket" "bucket" {
    bucket = "${var.username}-bucket-${var.environment}-day-09"

    tags = var.tags

    lifecycle {
      
      prevent_destroy = true // this prevents deletion when we run terraform destroy
    }
    
}

// Using ignore_changes to avoid updates to specific attributes
resource "aws_launch_template" "template" {
  name_prefix   = "day-09-template-"
  image_id      = "ami-0fa3fe0fa7920f68e"
  instance_type = "t3.micro"

  tag_specifications {
    resource_type = "instance"
    tags = merge(
        var.tags,
        {
            template = "launch template "
        }
    )
  }


}

resource "aws_autoscaling_group" "my_asg" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 2
  max_size           = 5
  min_size           = 1

  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }

  tag {
    key = "Name"
    value = "day-09-asg"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [ desired_capacity ]
  }



}


// Using replace_triggered_by to recreate resource when a specific attribute changes
resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Security group for application servers"

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  ingress {
    from_port   = 8000
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.tags,
    {
      Name = "App Security Group"
      Demo = "replace_triggered_by"
    }
  )
}


resource "aws_instance" "instance" {
    ami = "ami-0fa3fe0fa7920f68e"
    instance_type = "t3.micro"
    vpc_security_group_ids = [ aws_security_group.app_sg.id ]

    lifecycle {
      replace_triggered_by = [ aws_security_group.app_sg ]
    }
  
}

// precondition and postconditon examples
resource "aws_s3_bucket" "bucket" {
    bucket = "${var.username}-bucket-${var.environment}-day-09"

    tags = var.tags


    lifecycle {
      precondition {
        condition = contains(keys((var.tags )), "Compliance")
        error_message = "Tag 'Compliance' is required for this bucket."
      }

      postcondition {
        condition = contains(values((self.tags)), "soc3")
        error_message = "Tag 'Compliance' must have the value 'soc3'."
      }
    }


  
}





