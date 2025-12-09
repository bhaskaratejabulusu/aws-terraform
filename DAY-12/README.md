## #30daysofawsterraform - day-12: Advanced Functions in Terraform

**Advanced Functions in Terraform:**

Building upon the foundational functions covered in Day 11, today we explore more specialized functions that enhance Terraform's capability to handle complex data transformations, validations, and operations. These functions are essential for creating robust, production-ready infrastructure as code.

**Types of Advanced Functions:**

**Numeric Functions:**
Numeric functions are used to perform mathematical operations and manipulate numeric values. These functions allow you to perform calculations, absolute value operations, statistical operations, and other numeric transformations.
- Examples: `abs()`, `ceil()`, `floor()`, `max()`, `min()`, `sum()`, `sqrt()`

**Validation Functions:**
Validation functions are used to validate input values and ensure they meet specific criteria. These functions help enforce data integrity and prevent configuration errors by checking conditions and formats.
- Examples: `can()`, `regex()`, `length()`, `startswith()`, `endswith()`, `contains()`

**Date/Time Functions:**
Date and time functions are used to manipulate and format date and time values. These functions allow you to perform operations such as parsing, formatting, timestamping, and calculating time differences.
- Examples: `formatdate()`, `timeadd()`, `timestamp()`, `timecmp()`

**File Functions:**
File functions are used to read, manipulate, and check file contents and properties. These functions allow you to read files, check file existence, work with file paths, and perform other file-related operations.
- Examples: `file()`, `fileexists()`, `dirname()`, `basename()`, `jsondecode()`, `jsonencode()`

## Examples from DAY-12:

### 1. Numeric Functions - Cost Analysis and Management

**Absolute Values and Statistical Operations:**
```terraform
// variables.tf
variable "monthly_cost" {
  description = "The estimated monthly cost"
  type        = list(number)
  default     = [-100.5, 200.75, 300.0]
}

// main.tf
locals {
    // Convert negative costs to absolute values
    absolute_monthly_cost = [for cost in var.monthly_cost : abs(cost)]
    
    // Find maximum cost using max() function
    maximum_monthly_cost = max(local.absolute_monthly_cost...)
    
    // Calculate total cost using sum() function
    total_monthly_cost = sum(local.absolute_monthly_cost)
}

// outputs.tf
output "absolute_monthly_cost" {
    value       = local.absolute_monthly_cost
    description = "The absolute values of the estimated monthly costs"
}

output "maximum_monthly_cost" {
    value       = local.maximum_monthly_cost
    description = "The maximum estimated monthly cost"
}

output "total_monthly_cost" {
    value       = local.total_monthly_cost
    description = "The total estimated monthly cost"
}
```

### 2. Validation Functions - Input Validation and Quality Control

**Regex Validation and Length Checking:**
```terraform
// variables.tf
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

// main.tf
locals {
    instance_type = var.instance_type
    backup_file_name = var.backup_file_name
}

// outputs.tf
output "instance_type" {
    value       = local.instance_type
    description = "The type of instance being used"
}

output "backup_file_name" {
  value = local.backup_file_name
}
```

### 3. Date/Time Functions - Timestamp Management

**Current Timestamp and Date Formatting:**
```terraform
// main.tf
locals {
    // Get current timestamp
    current_time = timestamp()
    
    // Format timestamp to YYYY-MM-DD format
    formatted_time = formatdate("YYYY-MM-DD", local.current_time)
    
    // Create timestamped bucket name
    bucket_name_with_timestamp = "bhaskaratejabulusu-s3-bucket-${local.formatted_time}"
}

// outputs.tf
output "bucket_name_with_timestamp" {
    value       = local.bucket_name_with_timestamp
    description = "The S3 bucket name appended with the current timestamp"
}
```

### 4. File Functions - Configuration File Management

**File Existence Checking and JSON Processing:**
```terraform
// main.tf
locals {
    // Check if config file exists
    config_file_exists = fileexists("./config.json")
    
    // Conditionally load file content based on existence
    file_config = local.config_file_exists ? jsondecode(file("./config.json")) : { }
    
    // Get directory name from file path
    directory_name_of_file = dirname("./config.json")
    
    // Read specific value from JSON file
    username = jsondecode(file("./config.json")).username
}

// Create JSON file from variable data
resource "local_file" "my_json_file" {
  content = jsonencode(var.my_data)
  filename = "my_data.json"
}

// variables.tf
variable "my_data" {
  type = map(any)
  default = {
    name = "bhaskara"
    age  = 30
    is_active = true
  }
}

// outputs.tf
output "file_config" {
    value       = local.file_config
    description = "The configuration loaded from config.json file"
}

output "directory_name_of_file" {
    value       = local.directory_name_of_file
    description = "The directory name of the config.json file"
}

output "username" {
    value       = local.username
    description = "The username from the config file or default"
}
```

### 5. Collection Functions with Type Conversion - Region Management

**Set Operations and List Concatenation:**
```terraform
// variables.tf
variable "default_regions" {
  type    = list(string)
  default = ["us-east-1", "us-west-2", "us-east-1"]
}

variable "new_regions" {
  type = list(string)
  default = ["eu-west-1", "ap-south-1", "sa-east-1"]
}

// main.tf
locals {
    // Combine regions and remove duplicates using toset()
    combined_regions = toset(concat(var.default_regions, var.new_regions))
}

// outputs.tf
output "regions" {
    value       = local.combined_regions
    description = "The combined unique regions from default and new regions"
}
```

## Best Practices:

1. **Always validate inputs** using validation blocks with appropriate functions
2. **Handle file existence** gracefully using `fileexists()` before reading files
3. **Use appropriate numeric functions** for calculations to avoid precision issues
4. **Format timestamps consistently** across your infrastructure
5. **Combine functions effectively** to create robust data transformation pipelines