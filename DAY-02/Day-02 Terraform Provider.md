### Day-02: Terraform Provider



#### Terraform Provider

Terraform provider is a plugin which translates the terraform code/scripts written in HCL language to the language that is understood by the target API's which can be AWS, Azure, GCP or it can be other services such as Docker, k8s, etc



This terraform provider is initiated when we run terraform init command in the terminal.



Terraform documentation is used to write code for particular resources

the documentation varies from provider to provider.



In the terraform script, there are two versions

version = this version is the provider version maintained by provider (AWS, AZ, GCP)

required\_version = this version is terraform core version maintained by Hashicorp



##### Why version matters?

If we don't specify the version, the latest version will be used automatically. but using the latest version may not be compatible with the configuration. So, mentioning the version is a good practice.



##### Version Constraints

= 1.2.3 - Exact version



= 1.2 - Greater than or equal to

<= 1.2 - Less than or equal to

~> 1.2 - Pessimistic constraint (allow patch releases)

= 1.2, < 2.0 - Range constraint



Using pessimistic constraint for versions is a best practice.

