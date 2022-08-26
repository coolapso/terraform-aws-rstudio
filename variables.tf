locals {
  az = var.az != null ? var.az : "${var.region}b"
  ami_map = {
    "rstudio"      = data.aws_ami.rstudio.id
    "relevancelab" = data.aws_ami.relevance.id
    "custom"       = var.custom_ami
  }

  instance_map = {
    "rstudio"      = var.rstudio_instance_type
    "relevancelab" = "t2.large"
    "custom"       = var.instance_type
  }

  rstudio_address = {
    "rstudio"      = "http://${module.ec2_instance.public_dns}:8787"
    "relevancelab" = "https://${module.ec2_instance.public_dns}"
    "custom"       = "http://${module.ec2_instance.public_dns}"
  }

  rstudio_username = {
    "rstudio"      = "rstudio-user"
    "relevancelab" = "rstudio"
    "custom"       = "User unknown, please verify with the provided ami instructions"
  }

}


variable "az" {
  description = "Availability zone to place the instance at"
  type        = string
  default     = null
}

variable "region" {
  description = "Region to place resources"
  type        = string
  default     = "eu-central-1"
}

variable "ami_type" {
  description = "Type of AMI to use, cuda, tensorflow, custom"
  default     = "rstudio"
}

variable "custom_ami" {
  description = "Custom AMI Id to be used"
  default     = null
}

variable "instance_type" {
  description = "The type of ec2 instance to be used"
  default     = "t3.micro"
}

variable "rstudio_instance_type" {
  description = "Instance type to be used by rstudio AMI, use only GPU instances"
  type        = string
  default     = "g4dn.xlarge"
}

variable "create_key" {
  description = "Defines if ssh privatekey is going to be created"
  default     = true
}

variable "key_name" {
  description = "The ssh keypair name"
  default     = "RSTudio-SSH"
}

variable "monitoring" {
  description = "enables monitoring on the instance"
  default     = false
}
