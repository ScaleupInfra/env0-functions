provider "aws" {
  region = "us-east-2"
}

# Define Variables
variable "security_groups" {
  description = "List of security groups"
  type        = list(string)
  default     = ["sg-0bda1e9d218590d2b", "sg-084be08f88f1ad64e"]
}

variable "additional_tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default = {
    "Team"   = "DevOps"
    "Owner"  = "admin"
  }
}

# Outputs for Verification
output "sg_count" {
  value = length(var.security_groups)
}

output "first_sg" {
  value = element(var.security_groups, 0)
}

output "flat_tags" {
  value = flatten([
    ["env:production", "app:web"],
    ["tier:frontend", "region:us-east-2"]
  ])
}

output "all_tags" {
  value = merge(
    {
      "Environment" = "production"
      "Project"     = "example"
    },
    var.additional_tags
  )
}

resource "aws_instance" "env0" {
  ami           = "ami-09040d770ffe2224f" # Amazon Linux 2 AMI in us-east-2
  instance_type = "t2.micro"
  tags = merge(
    {
      "Environment" = "production"
      "Project"     = "example"
    },
    var.additional_tags
  )

  vpc_security_group_ids = [element(var.security_groups, 0)]

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }
}
