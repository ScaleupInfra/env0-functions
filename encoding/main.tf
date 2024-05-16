# Provider Configuration
provider "aws" {
  region = "us-east-2"
}

# Define Variables
variable "config_json" {
  description = "Configuration in JSON format"
  type        = string
  default     = "{\"key\":\"value\"}"
}

# Local Variables with Encoding Functions
locals {
  # Original string to be encoded
  original_string = "This is a sample string."

  # Base64 encode the original string
  encoded_string = base64encode(local.original_string)

  # Decode JSON configuration
  decoded_config = jsondecode(var.config_json)
}

# Example EC2 Instance Resource
resource "aws_instance" "env1" {
  ami           = "ami-09040d770ffe2224f" # Amazon Linux 2 AMI in us-east-2
  instance_type = "t2.micro"
  tags = {
    Name            = "EncodingInstance"
    Encoded_Message = local.encoded_string
    Decoded_Key     = local.decoded_config["key"]
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }
}

# Outputs for Verification
output "original_string" {
  value = local.original_string
}

output "encoded_string" {
  value = local.encoded_string
}

output "decoded_config" {
  value = local.decoded_config
}
