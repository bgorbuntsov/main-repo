output "instance_ip" {
  value       = aws_eip.static_ip.public_ip
  description = "IP attached to host"
}

output "aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_region_name" {
  value = data.aws_region.current.name
}

output "aws_region_description" {
  value = data.aws_region.current.description
}

output "aws_ami_id" {
  value = data.aws_ami.amazon-linux-2.id
}

output "aws_ami_name" {
  value = data.aws_ami.amazon-linux-2.name
}
