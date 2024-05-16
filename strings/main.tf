provider "aws" {
  region = "us-east-2"
}

variable "instance_base_name" {
  description = "Base name for instances"
  type        = string
  default     = "webapp"
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "production"
}

locals {
  joined_name = join("-", [var.instance_base_name, var.env])

  split_name = split("-", local.joined_name)

  replaced_name = replace(local.joined_name, "webapp", "service")

  trimmed_description = trimspace("   This is a description with leading and trailing spaces   ")
}

output "joined_name" {
  value = local.joined_name
}

output "split_name" {
  value = local.split_name
}

output "replaced_name" {
  value = local.replaced_name
}

output "trimmed_description" {
  value = local.trimmed_description
}

resource "aws_instance" "env0" {
  ami           = "ami-09040d770ffe2224f" 
  instance_type = "t2.micro"
  tags = {
    Name        = local.joined_name
    Description = local.trimmed_description
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }
}
