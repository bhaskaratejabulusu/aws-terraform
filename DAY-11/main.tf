locals {
  formatted_project_name = replace(lower(var.project_name)," ", "-")

  tags = merge(var.default_tags, var.org_tags)

  formatted_bucket_name = substr(replace(replace(lower(var.inconsistent_bucket_name), ".", "-"), "_", "-"),0,23)

  port_list = (split(",",var.ports))

  sg_rules = [ for port in local.port_list :
    {
        name = "port-${port}"
        port = tonumber(port)
    }
  
   ]

   instance = lookup(var.env_instances, var.environment, "t2.micro")



}

