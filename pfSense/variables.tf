variable "region" {
  description = "Define what region the instance will be deployed"
  default = "us-east-1"
}

variable "instance_type" {
  description = "AWS Instance type defines the hardware configuration of the machine"
  default = "t3.micro"
}

variable "ami" {
  description = "AWS AMI to be used"
  default = "ami-0f39554b9402dac80"
}

variable "vpc_id" {
  description = "AWS VPC to be used"
  default = "data.aws_vpc.default.id"

  
}