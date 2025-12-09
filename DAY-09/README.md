## #30daysofawsterraform - day-09: Terraform lifecycle management

**Lifecycle rules:**
In terraform lifecycle rules are the ones that actually controls how the resource is created/updated/destroyed.
- improve security
- Better maintenance of resources
- control over the resources
 
There are 6 rules to manage the lifecycle 
1. ignore_changes
2. prevent_destroy
3. replace_triggered_by
4. create_before_destroy
5. precondition
6. postcondition




**1. Create before destroy:**
If there is any change in the resource, this rule ensures that the resource with updated changes is created and then the old resource will be destroyed
- This reduces the downtime while making changes (Zero-downtime deployment)

example:
create an instance before destroying

```
// main.tf
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
```

**2. Prevent destroy:**
This rule prevents the resource from being destroyed accidentally.
example:
prevent destroy for s3 bucket
```
// main.tf
// prevent destroy to avoid accidental deletion
resource "aws_s3_bucket" "bucket" {
    bucket = "${var.username}-bucket-${var.environment}-day-09"

    lifecycle {
      prevent_destroy = true
    }

}
```
**3. Ignore changes:**
This rule ignores the changes made to the resource outside terraform.
example:
ignore changes to tags

```
// main.tf
// Ignore changes to tags
resource "aws_instance" "instance" {
    ami = "ami-0f64121fa59598bf7"
    instance_type = "t3.micro"
    region = tolist(var.allowed_region)[0]

    tags = var.tags

    lifecycle {
      ignore_changes = [tags]
    }

}
```
**4. Replace triggered by:**
This rule replaces the resource when there is a change in the specified attribute.
example:
replace resource when there is a change in instance_type
```
// main.tf
// Replace instance when there is a change in instance_type
resource "aws_instance" "instance" {
    ami = "ami-0f64121fa59598bf7"
    instance_type = "t3.micro"
    region = tolist(var.allowed_region)[0]

    tags = var.tags

    lifecycle {
      replace_triggered_by = [instance_type]
    }

}
```
**5. Precondition:**
This rule checks the condition before creating/updating the resource.
example:
```
// main.tf
// Precondition to check instance type
resource "aws_instance" "instance" {
    ami = "ami-0f64121fa59598bf7"
    instance_type = "t3.micro"
    region = tolist(var.allowed_region)[0]

    tags = var.tags

    lifecycle {
      precondition {
        condition     = var.instance_type == "t3.micro"
        error_message = "Instance type must be t3.micro"
      }
    }

} 
```
**6. Postcondition:**
This rule checks the condition after creating/updating the resource.
example:
``` 
// main.tf
// Postcondition to check instance state
resource "aws_instance" "instance" {
    ami = "ami-0f64121fa59598bf7"
    instance_type = "t3.micro"
    region = tolist(var.allowed_region)[0]

    tags = var.tags

    lifecycle {
      postcondition {
        condition     = aws_instance.instance.instance_state == "running"
        error_message = "Instance is not in running state"
      }
    }

} 
```

## Best practices:
- Use lifecycle rules to manage resources effectively.
- Always test the lifecycle rules in a non-production environment before applying them to production.
- Document the lifecycle rules used in the terraform code for better understanding and maintenance.
- Regularly review and update the lifecycle rules as per the changing requirements and best practices.
- Be cautious while using ignore_changes - it can hide important changes.
- Use create_before_destroy for critical resources to avoid downtime.

