data "aws_ami" "pfSense" {
  most_recent = true

  filter {
    name   = "name"
    values = ["pfSense*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"] # aws-marketplace
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.pfSense.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}