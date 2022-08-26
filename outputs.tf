output "address" {
  value = lookup(local.rstudio_address, var.ami_type)
}

output "dns_name" {
  value = module.ec2_instance.public_dns
}

output "ip_address" {
  value = module.ec2_instance.public_ip
}

output "instance_id" {
  value = module.ec2_instance.id
}
