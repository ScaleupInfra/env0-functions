provider "aws" {
  region = "us-east-2"
}

variable "condition" {
  description = "Condition to test ternary operator"
  type        = bool
  default     = true
}

variable "config_map" {
  description = "A map for configuration"
  type        = map(string)
  default     = {
    "key1" = "value1"
    "key2" = "value2"
  }
}

variable "instance_names" {
  description = "List of instance names"
  type        = list(string)
  default     = ["instance1", "instance2", "instance3"]
}

locals {
  # Conditional execution using ternary operator
  condition_result = var.condition ? upper("SUCCESS") : lower("FAILURE")

  # Accessing a specific map value using the lookup function
  specific_value = lookup(var.config_map, "key1", "default_value")

  # Accessing a specific list item using the element function
  specific_instance_name = element(var.instance_names, 1)

  # Using splat syntax to get all instance IDs
  instance_ids = aws_instance.env0[*].id

  # Joining instance IDs into a single string
  joined_instance_ids = join(",", local.instance_ids)
}

resource "aws_security_group" "env0" {
  name        = "env0_sg"
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

resource "aws_instance" "env0" {
  count = length(var.instance_names)

  ami           = "ami-09040d770ffe2224f" 
  instance_type = "t2.micro"
  tags = {
    Name            = var.instance_names[count.index]
    Condition_Result = local.condition_result
    Specific_Value  = local.specific_value
    Specific_Name   = local.specific_instance_name
  }

  vpc_security_group_ids = [aws_security_group.env0.id]

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }
}

output "condition_result" {
  value = local.condition_result
}

output "specific_value" {
  value = local.specific_value
}

output "instance_ids" {
  value = local.instance_ids
}

output "specific_instance_name" {
  value = local.specific_instance_name
}

output "joined_instance_ids" {
  value = local.joined_instance_ids
}
