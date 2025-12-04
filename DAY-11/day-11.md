## #30daysofawsterraform - day-11: Functions in Terraform

**Functions:**
A function is a predefined operation that takes one or more input values (arguments) and returns a single output value. Functions are used to perform common tasks, manipulate data, and transform values within Terraform configurations.
functions increse the reusability and modularity of Terraform code, making it easier to manage and maintain infrastructure as code.

- In terraform, we cannot create our own functions but we can use the built-in functions provided by terraform.

**Types of Functions in Terraform:**

**Validation Functions:**
Validation functions are used to validate input values and ensure they meet specific criteria. These functions help enforce
data integrity and prevent configuration errors.
- Examples: `can()`, `contains()`, `length()`, `regex()`, `alltrue()`, `anytrue()`

**String Functions:**
String functions are used to manipulate and transform string values. These functions allow you to perform operations such as concatenation, substring extraction, and case conversion.
- Examples: `concat()`, `join()`, `lower()`, `upper()`, `replace()`, `split()`, `trimspace()`

**Numeric Functions:**
Numeric functions are used to perform mathematical operations and manipulate numeric values. These functions allow you to perform calculations, rounding, and other numeric transformations.
- Examples: `abs()`, `ceil()`, `floor()`, `max()`, `min()`, `round()`, `sqrt()`

**Collection Functions:**
Collection functions are used to manipulate and transform collections such as lists, maps, and sets. These functions allow you to perform operations such as filtering, mapping, and aggregating values within collections.
- Examples: `length()`, `contains()`, `distinct()`, `flatten()`, `join()`, `lookup()`, `merge()`, `slice()`

**Type Conversion Functions:**
Type conversion functions are used to convert values from one data type to another. These functions allow you to change the type of a value to ensure compatibility with other operations or functions.
- Examples: `tostring()`, `tonumber()`, `tolist()`, `tomap()`, `toset()`

**Date and Time Functions:**
Date and time functions are used to manipulate and format date and time values. These functions allow you to perform operations such as parsing, formatting, and calculating time differences.
- Examples: `formatdate()`, `timeadd()`, `timestamp()`, `timecmp()`

**Lookup Functions:**
Lookup functions are used to retrieve values from maps or other data structures based on specified keys. These functions allow you to access specific values within complex data structures.
- Examples: `lookup()`, `element()`, `index()`

**Validation Functions:**
Validation functions are used to validate input values and ensure they meet specific criteria. These functions help enforce data integrity and prevent configuration errors.
- Examples: `can()`, `contains()`, `length()`, `regex()`, `alltrue()`, `anytrue()`

**File Functions:**
File functions are used to read and manipulate file contents. These functions allow you to read files, encode/decode file contents, and perform other file-related operations.
- Examples: `file()`, `filebase64()`, `filesha256()`, `templatefile()`


Examples:

1. Transform "Project ALPHA Resource" → "project-alpha-resource"

```
// variables.tf
variable "project_name" {
    default = "Project ALPHA Resource"
  
}

// main.tf
locals {
    formatted_name = lower(replace(var.project_name, " ", "-"))
}

//outputs.tf
output "formatted_name" {
    value = local.formatted_name
}

```

2. Resource Tagging - Merge default and environment tags
```
// variables.tf

variable "org_tags" {
  type = map(string)
  default = {
    "org" = "haschicorp"
    "project" = "automation"
  }
}

variable "default_tags" {
    type = map(string)
    default = {
      "env" = "dev"
      "name" = "env_tags"
    }
  
}

// main.tf
locals{
      tags = merge(var.default_tags, var.org_tags)
}
 // outputs.tf
output "merged_tags" {
    value = local.tags
}

```

3. Sanitize bucket names for AWS compliance

```
// variables.tf
variable "inconsistent_bucket_name" {
    type = string
    default = "My.Project_ALPHA.Bucket."
  
}

// main.tf
locals {
    sanitized_bucket_name = lower(replace(replace(trimspace(var.inconsistent_bucket_name), "_", "-"), ".", "-"))
}

// outputs.tf
output "sanitized_bucket_name" {
    value = local.sanitized_bucket_name
}
```

4. Security Group Ports - Transform "80,443,8080" into security group rules

```
// variables.tf
variable "allowed_ports" {
    type = string
    default = "80,443,8080"
  
}

// main.tf

  port_list = (split(",",var.ports))

  sg_rules = [ for port in local.port_list :
    {
        name = "port-${port}"
        port = tonumber(port)
    }
  
   ]

// outputs.tf
output "sg_rules" {
    value = local.sg_rules
}
```

5. Environment Lookup - Select instance size by environment
```
// variables.tf
variable "environment" {
    type = string
    default = "development"
  
}

variable "env_instances" {
    type = map(string)
    default = {
      "dev" = "t2.medium"
      "stage" = "t2.small"  
      "prod" = "t2.large"
    }
  
}

// main.tf
locals {
    instance_size = lookup(var.env_instances, var.environment, "t2.micro")
}

// outputs.tf
output "instance_size" {
    value = local.instance_size
}
```