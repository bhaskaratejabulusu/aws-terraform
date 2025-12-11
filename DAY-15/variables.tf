variable "primary_region" {
    type = string
    default = "us-east-1"
}

variable "secondary_region" {
    type = string
    default = "us-west-1"
}

variable "primary_vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
  
}

variable "secondary_vpc_cidr" {
    type = string
    default = "10.1.0.0/16"
  
}

variable "primary_sn_cidr" {
    type = string
    default = "10.0.14.0/24"
  
}

variable "secondary_sn_cidr" {
    type = string
    default = "10.1.12.0/24"
  
}

variable "primary_key_pair" {
    default = "primary"
  
}

variable "secondary_key_pair" {
    default = "secondary"
  
}

variable "primary_ingress_rules" {
    type = list(object({
      description = string
      protocol = string
      from_port = string
      to_port = string
      cidr_blocks = list(string)
    }))

    default = [ {
        description = "SSH from anywhere"
      protocol = "tcp"
      from_port = "22"
      to_port = "22"
      cidr_blocks = [ "0.0.0.0/0" ]
    },
    {
        description = "allow http from secondary vpc"
        protocol = "tcp"
        from_port = "0"
        to_port = "65535"
        cidr_blocks = [ "0.0.0.0/0" ]
    } 
    
    ]

    
  
}