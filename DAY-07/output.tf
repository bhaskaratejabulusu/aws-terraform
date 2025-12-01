output "deployment_summary" {
    description = "Summary of the deployment including environment, instance count, and name tag"
    value = {
        environment = var.environment
        instance_count = var.instance_count
        name_tag = var.tags["Name"]
    }
}