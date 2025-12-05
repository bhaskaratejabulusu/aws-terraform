locals {
    instance_type = var.instance_type
    backup_file_name = var.backup_file_name

    config_file_exists = fileexists("./config.json")
    file_config = local.config_file_exists ? jsondecode(file("./config.json")) : { }

    directory_name_of_file = dirname("./config.json")

    combined_regions = toset(concat(var.default_regions, var.new_regions))

    absolute_monthly_cost = [for cost in var.monthly_cost : abs(cost)]

    maximum_monthly_cost = max(local.absolute_monthly_cost...)

    total_monthly_cost = sum(local.absolute_monthly_cost)

    current_time = timestamp()

    formatted_time = formatdate("YYYY-MM-DD", local.current_time)

    bucket_name_with_timestamp = "bhaskaratejabulusu-s3-bucket-${local.formatted_time}"

    username = jsondecode(file("./config.json")).username 


}

resource "local_file" "my_json_file" {
  content = jsonencode(var.my_data)
  filename = "my_data.json"
  
}