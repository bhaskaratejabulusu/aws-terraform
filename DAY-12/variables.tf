  variable "instance_type" {
  description = "The type of instance to use"
  type        = string
  default     = "t2.micro"

  validation {
    condition = can(regex("^t[2-3]\\." , var.instance_type))
    error_message = "instance type must start with 't2.' or 't3.'"
  }

  validation {
    condition = length(var.instance_type) > 2 && length(var.instance_type) < 20
    error_message = "length of instance type must be between 2 and 20 characters"
  }
    
  }

  variable "backup_file_name" {
    description = "The name of the backup file"
    type        = string
    default     = "bucket_backup"
    
    validation {
      condition = endswith(var.backup_file_name, "_backup")
      error_message = "backup file must end with '_backup'"
    }

  }

  variable "credentials" {
    description = "Credentials for accessing the service"
    type        = string
    default = "bby@1223"
    sensitive   = true
    
  }


variable "default_regions" {
  type    = list(string)
  default = ["us-east-1", "us-west-2", "us-east-1"]
  
}

variable "new_regions" {
  type = list(string)
  default = ["eu-west-1", "ap-south-1", "sa-east-1"]
  
}

variable "monthly_cost" {
  description = "The estimated monthly cost"
  type        = list(number)
  default     = [-100.5, 200.75, 300.0]
  
}

variable "my_data" {
  type = map(any)
  default = {
    name = "bhaskara"
    age  = 30
    is_active = true
  }
  
}