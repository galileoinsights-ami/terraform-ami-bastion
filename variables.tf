variable "default_aws_tags" {
  description = "default aws tags"
  default = {}
}


variable "backend_s3_bucket_name" {
  description = "S3 bucket which contains remote state"
}

variable "bastion_users" {
  description = "List of all users who have to be added to bastion host. This is a list of strings. Each element in the list is of the format <username>;<ssh-public-key>"
  type = "list"
  default = []
}

# Can be set with environment variable TF_VAR_infrastructure_admin_private_key_file_path
variable "infrastructure_admin_private_key_file_path" {
  description = "Path to the Infrastructure Admin Private SSH Key"
  default = "~/.ssh/ami_infrastructure_admin"
}

variable "primary_domain" {
  description = "primary domain under which to create the Bastion DNS"
}