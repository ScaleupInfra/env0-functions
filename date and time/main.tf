# Provider Configuration
provider "aws" {
  region = "us-east-2"
}

# Example EC2 Instance Resource
resource "aws_instance" "env0" {
  ami           = "ami-09040d770ffe2224f" 
  instance_type = "t2.micro"
  tags = {
    Name            = "DateAndTimeInstance"
    Created_At      = timestamp()
    Backup_Schedule = timeadd(timestamp(), "168h")
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }
}

# Outputs for Verification
output "current_time" {
  value = timestamp()
}

output "backup_time" {
  value = timeadd(timestamp(), "168h")
}
