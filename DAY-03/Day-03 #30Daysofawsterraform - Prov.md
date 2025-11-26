### **Day-03: #30Daysofawsterraform - Provision and S3 bucket using Terraform**



#### How provisioning of resource works internally

Devops engineer writes terraform script and it calls the resource provider and upon calling the corresponding resource will be created/modified/removed accordingly.



##### Prerequisites for running terraform script

1\. AWS Account

2\. Aws CLI installed

3\. Connect to AWS using aws configure command

##### 

##### Syntax for terraform code for provisioning S3 bucket

For a resource to be provisioned, syntax is:



resource "resource\_type" "variable\_name"{

&nbsp;     bucket = "unique\_bucket\_name"

&nbsp;     tags = {

&nbsp;         Name = "My bucket"

&nbsp;         Environment = "Dev"

&nbsp;     }

}





##### Steps to run the terraform script for S3 bucket creation

1\. tf init

2\. tf plan --> shows the blueprint/summary about the resources that are                   going to be created/modified/deleted

3\. tf validate --> this validates the script

4\. tf apply --auto-approve --> this doesn't wait for the consent in the        CLI



After running this commands the S3 bucket will be created in the AWS 

&nbsp;

##### To delete the S3 bucket run the command

6\. tf destroy --auto-approve --> this destroys the resources 



After running this command the S3 bucket will be deleted in the AWS



This is how we will automate the creation and deletion of S3 bucket in AWS



Resources

Video : https://www.youtube.com/watch?v=09HQ\_R1P7Lw







