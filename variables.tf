locals {
  az = var.az != null ? var.az : "${var.region}b"
  ami_map = {
    "relevancelab" = var.ami_type == "relevancelab" ? data.aws_ami.relevancelab[0].id : null
    "custom"       = var.custom_ami
  }

  instance_map = {
    "relevancelab" = "t2.large"
    "custom"       = var.instance_type
  }

  rstudio_address = {
    "relevancelab" = "https://${module.ec2_instance.public_dns}"
    "custom"       = "http://${module.ec2_instance.public_dns}"
  }

  rstudio_username = {
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
  type        = string
  default     = "relevancelab"
}

variable "custom_ami" {
  description = "Custom AMI Id to be used"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "The type of ec2 instance to be used"
  type        = string
  default     = "t3.micro"
}

variable "create_key" {
  description = "Defines if ssh privatekey is going to be created"
  type        = bool
  default     = true
}

variable "key_name" {
  description = "The ssh keypair name"
  type        = string
  default     = "RSTudio-SSH"
}

variable "ec2_instance_name" {
  description = "The name of the ec2 instance"
  type        = string
  default     = "RStudio-Server"
}

variable "monitoring" {
  description = "enables monitoring on the instance"
  type        = bool
  default     = false
}

variable "associate_public_ip_address" {
  description = "Associate a public ip address with the instance"
  type        = bool
  default     = true
}
