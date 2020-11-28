### ---------------------------- Terraform v0.12.16 ----------------------------- ###

resource "aws_security_group" "allow_ssh_web" {
  name        = "allow_ssh_web"
  description = "Allow SSH (22TCP) and WEB (80TCP) inbound traffic"
  ingress {
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    to_port     = 80
    from_port   = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.tags, map("descr", "firewall_rule_to_allow_ssh_and_web"))
}

resource "aws_key_pair" "deployer" {
  key_name   = "autoload-deployer-local-key"
  public_key = var.my_ssh_pubkey
  tags = local.tags
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_ssh_web.id]
  tags                   = local.tags
  key_name               = "autoload-deployer-local-key"
  user_data              = file("deploy.sh")
}

output "instance_ip" {
  value       = aws_instance.web.public_ip
  description = "IP attached to host"
}

