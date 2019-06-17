# Backend Initialization using command line

terraform {
 backend "s3" {
   key = "bastion.tfstate"
 }
}

locals {
}

# Initializing the provider

# Following properties need to be set for this to work
# export AWS_ACCESS_KEY_ID="anaccesskey"
# export AWS_SECRET_ACCESS_KEY="asecretkey"
# export AWS_DEFAULT_REGION="us-west-2"
# terraform plan
provider "aws" {}

# Get the AMI to use
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

# Need the security Information to get the SSH Key info to bring up 
# EC2 instances
data "terraform_remote_state" "security" {
  backend = "s3"
  config {
    key = "security.tfstate"
    bucket = "${var.backend_s3_bucket_name}"
  }
}

# Need Network information to decide with Subnet and security group
# to apply to the bastion server
data "terraform_remote_state" "network" {
  backend = "s3"
  config {
    key = "network.tfstate"
    bucket = "${var.backend_s3_bucket_name}"
  }
}

# Need Domain information to setup bastion server DNS
data "aws_route53_zone" "primary_domain" {
  name = "${var.primary_domain}"
}

resource "template_dir" "config" {
  source_dir      = "${path.cwd}/scripts_templates"
  destination_dir = "${path.cwd}/scripts"

  vars {
    bastion_users = "${join(",",var.bastion_users)}"
  }
}


resource "aws_instance" "bastion" {

  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t3.nano"

  
  key_name = "${data.terraform_remote_state.security.infrastructure_admin_key_name}"

  vpc_security_group_ids = ["${data.terraform_remote_state.network.default_security_group_id}",
                                "${data.terraform_remote_state.network.bastion_security_group_id}"]
  subnet_id = "${element(data.terraform_remote_state.network.public_subnets,0)}"

  associate_public_ip_address = true

  provisioner "file" {
    source      = "scripts/user_creation_script.sh"
    destination = "/tmp/user_creation_script.sh"

    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = "${file(var.infrastructure_admin_private_key_file_path)}"
    }
  }

  
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/user_creation_script.sh",
      "sudo bash /tmp/user_creation_script.sh",
    ]

    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = "${file(var.infrastructure_admin_private_key_file_path)}"
    }
  }


  tags = "${merge(map("Name", "bastion"),var.default_aws_tags)}"

}


resource "aws_route53_record" "bastion" {
  zone_id = "${data.aws_route53_zone.primary_domain.zone_id}"
  name    = "bastion"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.bastion.public_ip}"]
}