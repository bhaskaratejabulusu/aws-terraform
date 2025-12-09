### 30DaysOfAwsTerraform - Day - 01: Introduction to Infra as a Code (IAC) and Terraform

### 
 
### Infra as a Code:

write the code to provision resources (servers, database, vpc etc..)



##### Tools for Infra as a code:

Terraform - universal and most popular in the tech industry

Pulumi - universal

Cloud native

 		Azure - ARM, Bicep

 		AWS - cloud formation, CDK

 		GCP - Deployment manager, config controller



### Why IAC ?

To create a simple 3 tier architecture \[web, app, db], we need to create everything manually using GUI and it takes around 2+ hours to provision the resources for the application.

Now, for an enterprise application, it becomes more complex and as the complexity increases, the provisioning of resources takes more time to provision the resources.

and updating, deleting the resources also takes time.

To avoid this we use IAC (infrastructure as code)



by manually provisioning the resources we can face errors such as

 	Time, people, cost, Insecure, human errors, 'It works on my machine'





### How terraform helps ?

It automates the resource provisioning which saves time, cost and also better security compared to manual provisioning.

Easily maintainable as we can update resources by just configuring the code



Pros:

 	Save time

 	Consistent

 	Write once, Deploy many times

 	Track changes -- version control -- No Blame Game

 	life easy





### How Terraform works:

Terraform files are saved using .tf extension and we use HCL \[ hashicorp configuration language] for terraform - similar to json

HCL is human and machine readable language



### Flow:

1. The devops engineer writes the terraform code
2. pushes the code into GitHub (version control)
3. now it automates using CICD pipeline or use CLI to run the terraform file(s)
4. usually we run 4 commands to automate the resource provisioning using terraform

*  	terraform init - initializes the infrastructure
*  	terraform validate - to check any syntax errors and validates them
*  	terraform plan - gives DRY run and provides a preview the resources that are going to be provisioned
*  	terraform apply - it now actually runs and provision the resources by internally calling/interacting AWS API's
*  	terraform destroy - this command is used to delete the infrastructure





we can install terraform by using running some commands depending on the operating system. 

