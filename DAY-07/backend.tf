terraform {
    backend "s3" {
    bucket = "bhaskaratejabulusu-state-files-day06"
    key = "dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true

  }
}