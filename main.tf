provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "dev-vpc"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.vpc.id
  for_each                = var.subnets
  cidr_block              = each.value.cidr
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    "Name" = each.value.name
  }
}

resource "aws_subnet" "subnets" {
  vpc_id                  = aws_vpc.vpc.id
  for_each                = var.subnets
  cidr_block              = each.value.cidr
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    "Name" = each.value.name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  depends_on = [ aws_vpc.vpc ]
  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = "dev-rt"
  }
}

resource "aws_route_table_association" "rta" {
  for_each       = aws_subnet.subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.rt.id

}

resource "aws_security_group" "sg" {
  name        = "allow SSH"
  description = " Allow inbound and  outbound Traffic"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "dev-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "inbound" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = aws_vpc.vpc.cidr_block
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "outbound" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# resource "aws_instance" "dev-ec2" {
#   for_each      = aws_subnet.subnet
#   subnet_id     = each.value.id
#   ami           = "ami-012967cc5a8c9f891"
#   instance_type = "t2.micro"
#   key_name      = "new-login"
#   tags = {
#     Name      = "dev-ec2"
#     Createdby = "terraform"
#   }
#   vpc_security_group_ids = [aws_security_group.sg.id]
# }

resource "aws_instance" "dev-ec2" {                     
  for_each      = var.subnets                            #for each subnet each ec2
  ami           = "ami-012967cc5a8c9f891"
  instance_type = "t2.micro"
  key_name      = "new-login"
  tags = {
    Name      = each.value.name
    Createdby = "terraform"
  }
  vpc_security_group_ids = [aws_security_group.sg.id]
}