resource "aws_security_group" "pfsense_first_access" {
  name          = "pfsense_first_access"
  description   = "acesso portas ssh e http(s)"
  vpc_id        = aws_vpc.groove.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    
  tags          = {
    Name        = "First access (Remover ao Configurar)"
  }
}
resource "aws_security_group" "pfsense_trust_openvpn_access" {
  name          = "pfsense_trust_openvpn_access"
  description   = "Acesso OpenVPN"
  vpc_id        = aws_vpc.groove.id  
  
  
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acesso VPN Config Access"
  }
  ingress {
    from_port   = 1195
    to_port     = 1195
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acesso VPN Monitoring"
  }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Regra de saida"
  }
tags          = {
    Name        = "Trust access OpenVPN"
  }
}
resource "aws_security_group" "pfsense_trust_ipsec_access" {
  name          = "pfsense_trust_ipsec_access"
  description   = "Acesso IpSec"
  vpc_id        = aws_vpc.groove.id

  
  
  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acesso IpSec"
  }
  
    ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["10.32.16.0/24"]
    description = "Acesso IPSEC Groove Tech"
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["10.10.35.0/24"]
    description = "Acesso IPSEC Equals Oracle"
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["172.16.1.0/24"]
    description = "Acesso IPSEC Equals AWS 1"
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["172.16.2.0/24"]
    description = "Acesso IPSEC Equals AWS 2"
  }
  
tags          = {
    Name        = "Trust access IpSec"
  }
}
resource "aws_security_group" "pfsense_trust_ipforce_access" {
  name          = "pfsense_trust_ipforce_access"
  description   = "Acesso IP Force"
  vpc_id        = aws_vpc.groove.id  
  
  
  ingress {
    from_port   = 8109
    to_port     = 8109
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acesso Painel Administrativo IP Force"
  }
  ingress {
    from_port   = 6109
    to_port     = 6109
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acesso SIP Zoiper"
  }
tags          = {
    Name        = "Trust access IP Phone"
  }
}