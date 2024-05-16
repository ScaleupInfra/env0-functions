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

# Outputs for Verification
output "abs_disk_size" {
  value = abs(var.desired_disk_size)
}

output "ceil_cpu" {
  value = ceil(var.desired_cpu)
}

output "floor_cpu" {
  value = floor(var.desired_cpu)
}

output "tags" {
  value = {
    Name = "env0-numeric"
    CPU_Ceiled   = tostring(ceil(var.desired_cpu))
    CPU_Floored  = tostring(floor(var.desired_cpu))
    Disk_AbsSize = tostring(abs(var.desired_disk_size))
  }
}

# Example EC2 Instance Resource
resource "aws_instance" "env0" {
  ami           = "ami-09040d770ffe2224f"
  instance_type = "t2.micro"
  tags = {
    Name        = "env0-numeric"
    CPU_Ceiled  = tostring(ceil(var.desired_cpu))
    CPU_Floored = tostring(floor(var.desired_cpu))
    Disk_AbsSize = tostring(abs(var.desired_disk_size))
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = abs(var.desired_disk_size)
  }
}
