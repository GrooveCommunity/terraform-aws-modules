resource "aws_security_group" "pfsense_22" {
  name          = "pfsense_ssh"
  description   = "acesso porta 22"
  vpc_id        = aws_vpc.groove.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags          = {
    Name        = "ssh first access"
  }
}
resource "aws_security_group" "pfsense_80" {
  name          = "pfsense_http"
  description   = "acesso porta 80"
  vpc_id        = aws_vpc.groove.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags          = {
    Name        = "http first access"
  }
}