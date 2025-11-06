variable "region" { default = "us-east-1" }
variable "project_name" { default = "login-demo" }
variable "docker_image_tag" { default = "latest" }
variable "ssh_cidr" { description = "Your IP for SSH", default = "REPLACE_ME_SSH_CIDR/32" }
variable "instance_type" { default = "t3.micro" }
variable "key_name" { description = "EC2 SSH key pair name (must exist in region)" default = "REPLACE_ME_KEYNAME" }
