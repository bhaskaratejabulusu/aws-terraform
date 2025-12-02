variable "username" {
    type = string
    default = "bhaskaratejabulusu"
  
}

variable "bucket_count_list" {
    type = list(string)
    default = [ "bhaskaratejabulusu-bucket-day-08-list-1", 
                    "bhaskaratejabulusu-bucket-day-08-list-2" ]
}

variable "bucket_count_set" {
    type = set(string)
    default = [ "bhaskaratejabulusu-bucket-day-08-set-1", 
                    "bhaskaratejabulusu-bucket-day-08-set-2" ]
  
}

variable "bucket_count_map" {
    type =  map(string)
    default = {
        "bucket1" = "bhaskaratejabulusu-bucket-day-08-map-1",
        "bucket2" = "bhaskaratejabulusu-bucket-day-08-map-2"
    }
  
}

