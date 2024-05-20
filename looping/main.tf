provider "aws" {
  region = "us-east-1"
}

variable "tags" {
  type = map(string)
  default = {
    Name        = "ExampleInstance"
    Environment = "Dev"
    Owner       = "Admin"
  }
}

variable "create_extra_instance" {
  type    = bool
  default = false
}

variable "servers" {
  type = map(string)
  default = {
    server1 = "t2.micro",
    server2 = "t3.small",
    server3 = "t3.medium"
  }
}

resource "aws_instance" "example" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t3.nano"

  tags = { for key, value in var.tags : upper(key) => lower(value) }
}

resource "aws_instance" "server" {
  for_each = var.servers

  ami           = "ami-04b70fa74e45c3917"
  instance_type = each.value

  tags = {
    Name = each.key
  }
}

resource "aws_instance" "extra" {
  count = var.create_extra_instance ? 1 : 0

  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t3.nano"

  tags = {
    Name = "ExtraInstance"
  }
}

output "example_instance_id" {
  value = aws_instance.example.id
}

output "example_instance_public_ip" {
  value = aws_instance.example.public_ip
}

output "server_instance_ids" {
  value = { for k, v in aws_instance.server : k => v.id }
}

output "server_instance_public_ips" {
  value = { for k, v in aws_instance.server : k => v.public_ip }
}

output "extra_instance_id" {
  value = length(aws_instance.extra) > 0 ? aws_instance.extra[0].id : null
}

output "extra_instance_public_ip" {
  value = length(aws_instance.extra) > 0 ? aws_instance.extra[0].public_ip : null
}
