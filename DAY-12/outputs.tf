output "instance_type" {
    value       = local.instance_type
    description = "The type of instance being used"
  
}

output "backup_file_name" {
  value = local.backup_file_name
}

output "credentials" {
    value       = var.credentials
    description = "The credentials used for accessing the service"
    sensitive   = true
  
}

output "file_config" {
    value       = local.file_config
    description = "The configuration loaded from config.json file"
  
}

output "directory_name_of_file" {
    value       = local.directory_name_of_file
    description = "The directory name of the config.json file"
  
}

output "regions" {
    value       = local.combined_regions
    description = "The combined unique regions from default and new regions"
  
}

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

output "bucket_name_with_timestamp" {
    value       = local.bucket_name_with_timestamp
    description = "The S3 bucket name appended with the current timestamp"
  
}

output "username" {
    value       = local.username
    description = "The username from the config file or default"
  
}