output "instance_ip" {
  value       = aws_eip.static_ip.public_ip
  description = "IP attached to host"
}

output "aws_caller_identity" {
  value = data.aws_caller_identity.current.account.id
}
