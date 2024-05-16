provider "aws" {
  region = "us-east-2"
}

# Define Variables
variable "desired_cpu" {
  description = "Desired CPU allocation"
  type        = number
  default     = 3.7
}

variable "desired_disk_size" {
  description = "Desired Disk Size"
  type        = number
  default     = -100
}

# Local Variables
locals {
  # Using abs to get the absolute value of the desired disk size
  abs_disk_size = abs(var.desired_disk_size)

  # Using ceil to round up the desired CPU allocation
  ceil_cpu = ceil(var.desired_cpu)

  # Using floor to round down the desired CPU allocation
  floor_cpu = floor(var.desired_cpu)

  # Tags using the calculated values
  tags = {
    Name = "env0-numeric"
    CPU_Ceiled   = tostring(local.ceil_cpu)
    CPU_Floored  = tostring(local.floor_cpu)
    Disk_AbsSize = tostring(local.abs_disk_size)
  }
}

# Outputs for Verification
output "abs_disk_size" {
  value = local.abs_disk_size
}

output "ceil_cpu" {
  value = local.ceil_cpu
}

output "floor_cpu" {
  value = local.floor_cpu
}

output "tags" {
  value = local.tags
}

# Example EC2 Instance Resource
resource "aws_instance" "env0" {

  ami           = "ami-09040d770ffe2224f" 
  instance_type = "t2.micro"
  tags          = local.tags

  root_block_device {
    volume_type = "gp2"
    volume_size = local.abs_disk_size
  }
}
