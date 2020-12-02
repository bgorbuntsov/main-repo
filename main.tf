### ---------------------------- Terraform v0.12.16 ----------------------------- ###

variable "env" {
  default = "dev"
}

variable "ec2_size" {
  default = {
    "prod"  = "t3.micro"
    "dev"   = "t2.micro"
    "stage" = "t2.nano"
  }
}

resource "aws_security_group" "allow_ssh_web" {
  name        = "allow_ssh_web"
  description = "Allow SSH (22TCP) and WEB (80TCP) inbound traffic"

  dynamic "ingress" {
    for_each = [22, 80]
    content {
      to_port     = ingress.value
      from_port   = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
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
  tags       = local.tags
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = lookup(var.ec2_size, var.env)
  vpc_security_group_ids = [aws_security_group.allow_ssh_web.id]
  tags                   = local.tags
  key_name               = "autoload-deployer-local-key"
  user_data              = file("deploy.sh")
}

resource "aws_eip" "static_ip" {
  instance = aws_instance.web.id
  tags     = merge(local.tags, map("description", "static_ip_address_for_${aws_instance.web.id}"))
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
