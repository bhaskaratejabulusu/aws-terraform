## #30daysofawsterraform - day-08 : Meta arguments in terraform

## Meta arguments
In terraform, the meta arguments are classified into 5 types
- depends_on
- count
- for_each
- provider
- lifecycle


![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/dydrm9ur0mf6y4ax9bcy.png)

**count:**
An argument used to create multiple resources with numeric indexing.
Usually, this is the length of the list.
- used for iterating over a list

example code:
```
// variables.tf
variable "bucket_count_list" {
    type = list(string)
    default = [ "bhaskaratejabulusu-bucket-day-08-list-1", 
                    "bhaskaratejabulusu-bucket-day-08-list-2" ]
}

// main.tf
resource "aws_s3_bucket" "bucket1" {
    count = length(var.bucket_count_list)
    bucket = var.bucket_count_list[count.index] // iterates over a list 
                                                   from 0 to [count-1]
  
}

```

**for_each**
An argument in terraform to create multiple resources with map/sets
- iterates over values / key-value pairs
- used in maps and sets

to use for_each the datatype must be either map or a set

example for set and map:
```
// variables.tf

// set
variable "bucket_count_set" {
    type = set(string)
    default = [ "bhaskaratejabulusu-bucket-day-08-set-1", 
                    "bhaskaratejabulusu-bucket-day-08-set-2" ]
  
}

// map
variable "bucket_count_map" {
    type =  map(string)
    default = {
        "bucket1" = "bhaskaratejabulusu-bucket-day-08-map-1",
        "bucket2" = "bhaskaratejabulusu-bucket-day-08-map-2"
    }
  
}


// main.tf

// using set
resource "aws_s3_bucket" "bucket2" {
    for_each = var.bucket_count_set
    bucket = each.value // iterates over the set using a for loop 
                             internally and retrieves every value

}

// using map
resource "aws_s3_bucket" "bucket3" {
    for_each = var.bucket_count_map
    bucket = each.value

}
```

**depends_on**
An argument used to explicitly specify that a resource or module must be created or updated after one or more other resources or modules. It establishes a manual dependency, ensuring the correct order of operations, even when there’s no direct reference between the resources.

example:
```
// main.tf
resource "aws_s3_bucket" "bucket1" {
    count = length(var.bucket_count_list)
    bucket = var.bucket_count_list[count.index]
  
}

resource "aws_s3_bucket" "bucket2" {
    for_each = var.bucket_count_set
    bucket = each.value

    depends_on = [ aws_s3_bucket.bucket1 ]
  
}
```
In the above code, the bucket2 is dependent on bucket1 so terraform will wait for bucket1 to be created and then bucket2 will be created ensuring the correct order.

