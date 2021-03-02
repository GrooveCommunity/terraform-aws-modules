provider "aws" {
   region = var.region
}

resource "aws_instance" "pfSense" {
  count = 1
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name        = "pfSense_${count.index}"
    Environment = "prod"
  }
}

resource "aws_security_group" "pt_22" {
  name = "pt_22"
  vpc_id = var.vpc_id
  ingress {
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
}

resource "aws_security_group" "pt_80" {
  name = "pt_80"
  vpc_id = var.vpc_id
  ingress {
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
}


