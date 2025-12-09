## 30DaysOfAwsTerraform - Day - 04: Terraform State Management and Remote Backend

## How terraform updates Infrastructure ?
When we run the terraform apply command, some files are created such as terraform.tfstate, terraform.tfstate.backup and terraform compares desired state with the actual state and provision the resources and update the infrastructure accordingly.

Desired state: The infrastructure we wish to create
Actual state: The current infrastructure we are having

**State file management**
In the terraform.tfstate, terraform.tfstate.backup files, sensitive information such as account Id's and resource names are present and in addition to that, modifying these files makes the state files corrupted. So, we shouldn't store in the production server or locally. To overcome this we store the state files in the remote backend instead of storing directly in the server

Storing the state files in the remote backend such as AWS S3 secures and stores separately which is easy to manage.

State file Best practices:
1. Store file to Remote backend
2. Don't update/delete the files
3. State locking --> a process which locks the file making the file inaccessible for others
4. Isolation of state file --> separate state files for different environments
5. Regular backup

**Code for storing state files in the Remote backend (S3 Bucket)**

```
terraform {
  backend "s3" {
    bucket = "bhaskaratejabulusu-state-files-day04"
    key = "dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true

  }
}
```

Make sure that the remote backend in this case S3 bucket is already created/available before running the terraform commands.
Usually this is done by CI/CD pipeline before terraform provisions resources


Security in S3 bucket:
1. S3 versioning enable
2. IAM minimal to S3
3. S3 Bucket Policy
4. Encryption (Server Side Encryption)
5. Access Logging


`terraform state list`
You can use the above command to list resources in state
