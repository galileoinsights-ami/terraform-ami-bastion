# Setting up Bastion Server with Terraform

This is used to create a bastion server, which can be used as a bridge to access all the assets within the VPC.

## Pre Requisites

1. **Pre-Commit Git Hook**: Install `pre-commit`. Visit https://pre-commit.com/. This is used to clean up the code before commiting to git.
2. **AWS Secret Scanner**: Install git-secrets. Visit https://github.com/awslabs/git-secrets. This is used to scan for aws credentials before a commit occurs.
3. **Terraform**: v0.11 Installed
4. **Execute AMI-Network**: Run [AMI-Security Terraform module](https://github.com/galileoinsights-ami/terraform-ami-network)
5. Have a `setup.sh` file which exports all the environment varibles mentioned below in the root directory of this workspace

## Setup Environment Variable

Following Environment Variables need to be setup.

Variable Name | Description | Required? | Example Values
---|---|---|---
ENV | The environment of this AWS Setup | Yes | dev, prod
AWS_ACCESS_KEY_ID | AWS Access key of user `TFNetwork` | Yes |
AWS_SECRET_ACCESS_KEY | AWS Access Secret Key of user `TFNetwork` | Yes |
AWS_DEFAULT_REGION | The AWS Region to work with | Yes | us-east-2
TF_VAR_backend_s3_bucket_name | The S3 Terraform Backend Bucket | Yes | ami-terraform-configs
TF_VAR_infrastructure_admin_private_key_file_path | Path to the private key of the Infrastructure KeyPair used to spin up EC2 instances | Yes | SSH Private Key File Path

## Before Committing

1. Scan for Secrets in to be committed files

```
git secrets --scan -r
git secrets --scan --cached --no-index --untracked
```

## Executing Terraform

Execute `deploy.sh` file

```
export ENV="dev";./deploy.sh
```


## Adding\Removing new Bastion Users

From time to time there will a necessasity to add or remove users who can SSH or Tunnel using the bastion Server. This can be done as follows:

1. Modify the environment specific `.tfvars` file to add or remove users from the `bastion_users` variable. For new users, you will need their SSH public key.
2. Destroy the bastion server.
	```
	export ENV="dev";./destroy.sh
	```
3. Redeploy Bastion Server
	```
	export ENV="dev";./deploy.sh
	```