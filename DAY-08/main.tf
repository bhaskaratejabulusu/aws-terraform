resource "aws_s3_bucket" "bucket1" {
    count = length(var.bucket_count_list)
    bucket = var.bucket_count_list[count.index]
  
}

resource "aws_s3_bucket" "bucket2" {
    for_each = var.bucket_count_set
    bucket = each.value

    depends_on = [ aws_s3_bucket.bucket1 ]
  
}

resource "aws_s3_bucket" "bucket3" {
    for_each = var.bucket_count_map
    bucket = each.value

    # logically depends on both bucket1 and bucket2 creation
    depends_on = [ aws_s3_bucket.bucket2 ]
  
}

output "list_bucket_names" {
    value = [ for bucket in aws_s3_bucket.bucket1 : bucket.bucket]
}

output "set_bucket_names" {
    value = [for bucket in aws_s3_bucket.bucket2 : bucket.bucket]
  
}

output "list_bucket_ids" {
    value = [ for bucket in aws_s3_bucket.bucket1 : bucket.id]
  
}

output "set_bucket_ids" {
    value = [ for bucket in aws_s3_bucket.bucket2 : bucket.id]
  
}

# iterating over map values to get bucket names
output "map_bucket_names" {
    value = [ for bucket in values(aws_s3_bucket.bucket3) : bucket.bucket ]
  
}

# iterating over map values to get bucket ids
# output "map_bucket_ids" {
#     value = [ for bucket in values(aws_s3_bucket.bucket3) : bucket.id ]
  
# }

# this output shows how to get both key and value from the map
# output "map_bucket_output" {
#     value = { for key, bucket in aws_s3_bucket.bucket3 : key => bucket.bucket }
  
# }
