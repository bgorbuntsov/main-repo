output "instance_ip" {
  value       = aws_eip.static_ip.public_ip
  description = "IP attached to host"
}
