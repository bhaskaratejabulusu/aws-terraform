**File Structure**
Keeping everything such as variables, locals, providers, backend, outputs, resources related code in one file isn't a best practice and becomes an overhead as infrastructure grows

There is a standard structure that needs to be followed by every DevOps engineer and one of the recommended project structure is:

project-root/
├── backend.tf           # Backend configuration
├── provider.tf          # Provider configurations
├── variables.tf         # Input variable definitions
├── locals.tf           # Local value definitions
├── main.tf             # Main resource definitions
├── vpc.tf              # VPC-related resources
├── security.tf         # Security groups, NACLs
├── compute.tf          # EC2, Auto Scaling, etc.
├── storage.tf          # S3, EBS, EFS resources
├── database.tf         # RDS, DynamoDB resources
├── outputs.tf          # Output definitions
├── terraform.tfvars   # Variable values
└── README.md           # Documentation

**Terraform File Loading**
- Terraform loads all the files with .tf extension in the current directory
- Terraform loads the files in lexicographical order (Alphabetical)
- File names doesn't affect any code inside them


- The above file structure is just an example and recommended by Hashicorp  and this varies from organization and their use case
- Another approach is to separate the files based on the environments or based on the resources as well