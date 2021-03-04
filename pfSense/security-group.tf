resource "aws_security_group" "pfsense" {
  name        = "pfsense"
  description = "acesso-ssh"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr]
  }
  tags = {
    Name = "ssh"
  }
}