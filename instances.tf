resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "this" {
  content         = tls_private_key.keypair.private_key_pem
  filename        = var.filename_keypair
  file_permission = "600"
}

resource "aws_key_pair" "main" {
  key_name   = var.name_keypair
  public_key = tls_private_key.keypair.public_key_openssh
}


resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = local.vpc_id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "allow_http"
  })

  depends_on = [data.aws_vpc.selected]

}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "allow_ssh"
  })
  depends_on = [data.aws_vpc.selected]
}


resource "aws_instance" "this" {
  count                       = length(var.vpc_availability_zones)
  ami                         = var.ec2_ami
  instance_type               = var.ec2_instance_type
  subnet_id                   = var.private_subnets[count.index]
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id]
  key_name                    = aws_key_pair.main.key_name
  associate_public_ip_address = var.ec2_enable_public_ip
  tags = merge(var.tags, {
  Name = "example" })

  depends_on = [data.aws_vpc.selected]


}


