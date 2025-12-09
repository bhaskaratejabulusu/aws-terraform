variable "s3_bucket_name" {
  description = "The name of the S3 bucket to create"
  type        = string
  
}

// Read bucket policy from json file
variable "bucket_policy_file" {
  description = "The file name that contains the bucket policy in JSON format"
  type        = string
  default = "bucket_policy.json.tmpl"
}

variable "s3_origin_id" {
  default = "S3-StaticWebsiteOrigin"
}