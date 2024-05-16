provider "aws" {
  region = "us-east-2"
}

variable "environment" {
  description = "The environment for deployment"
  type        = string
  default     = "dev"
}

variable "base_tags" {
  description = "Base tags for all instances"
  type        = map(string)
  default     = {
    Project = "MyProject"
    Owner   = "TeamA"
  }
}

variable "env_config" {
  description = "Environment-specific configurations"
  type        = map(object({
    instance_type = string
    extra_tags    = map(string)
    create_extra  = bool
  }))
  default = {
    dev = {
      instance_type = "t3.micro"
      extra_tags = {
        Environment = "Development"
      }
      create_extra = false
    }
    staging = {
      instance_type = "t3.small"
      extra_tags = {
        Environment = "Staging"
      }
      create_extra = true
    }
    prod = {
      instance_type = "t3.medium"
      extra_tags = {
        Environment = "Production"
      }
      create_extra = true
    }
  }
}

locals {
  instance_type = lookup(var.env_config[var.environment], "instance_type", "t3.micro")

  tags = merge(var.base_tags, lookup(var.env_config[var.environment], "extra_tags", {}))

  create_extra = lookup(var.env_config[var.environment], "create_extra", false)
}

resource "aws_security_group" "example" {
  name        = "${var.environment}_sg"
  description = "Allow all inbound traffic"
  vpc_id      = "vpc-0e7ac3d845c64c3cf" 

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Resource to create an EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-09040d770ffe2224f" # Example AMI ID for us-east-1
  instance_type = local.instance_type

  tags = local.tags

  vpc_security_group_ids = [aws_security_group.example.id]

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }
}

# Conditional resource creation for additional instances (e.g., monitoring)
resource "aws_instance" "extra" {
  count = local.create_extra ? 1 : 0

  ami           = "ami-09040d770ffe2224f"
  instance_type = "t3.nano"

  tags = merge(local.tags, { Name = "ExtraInstance" })

  vpc_security_group_ids = [aws_security_group.example.id]

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }
}

output "instance_type" {
  value = local.instance_type
}

output "tags" {
  value = local.tags
}

output "extra_instance_created" {
  value = local.create_extra
}
