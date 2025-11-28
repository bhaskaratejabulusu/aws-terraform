## 30daysofawsterraform day-05: Terraform variables in AWS

**Why do we need variables ?**
To use the specific value repeatedly such as environment, tag names, bucket names etc., instead of writing the same value everywhere we just store them and use when needed which increases reusability in the code. 

**Variables**
Variables are classified into two types
1. Based on purpose
2. Based on Value

**Based on Purpose**
- Input
- Output
- Local

**Based on value**
- Primitive --> String, number, bool
- Complex --> list, tuple, set, map, object
- ANY and NULL

**Input Variables**
variables which are used in the code when needed
Syntax:

```
variable "variable_name"{

     default = "dev"
     type = string  //this is not mandatory. if you don't mention the type of the variable, the terraform will autodetect and use ANY type
}

# Accessing the Variable
var.variable_name
${} // for concatenation of string

#Example:
Name = "${var.variable_name} - Bucket"
```

**Local variables**
variables declared in the locals block and accessed anywhere in the code
Syntax:

```
locals{
   env = "value"
   bucket_name="value"
}

#Accessing locals
local.local_variable_name
```

**Output Variable**
the variable which gives output once the resource has been provisioned and the output variables are generally printed on the console
Syntax:

```
output "variable_name"{
    value = value // Value of the variable you want as output
    description = "description_about_the_output_variable"
}
```

**Ways to declare variables**
we can declare variables in many ways:

1. Using the default
2. Environment variables
`export TF_VAR_variable_name="variable_value"`
3. using terraform.tfvars file 
`variable = "variable_value"`
4. using terraform.tfvars.json file (similar to terraform.tfvars file but in json format)
5. *auto.tfvars (or) *.auto.tfvars.json files
6. ANY -var in CLI
`terraform plan -var="variable=variable_value"`
7. ANY -var-file (variable files) 
```
# In variables.tfvars
variable "variable_name"{
   default = "variable_value"
}

# Use this file in command line
terraform plan -var-file=variables.tfvars

```

**Commands**
```
terraform output  #show all outputs
terraform output variable_name      # show the output of specific variable
terraform output -json       #show the outputs in json format

# Clean up 
unset TF_VAR_variable_name
```

In this way we create variables in different ways.
