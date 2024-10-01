resource "aws_vpc" "prathibha" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "prathibha"
  }
}
resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.prathibha.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
    tags = {
      Name = "subnet1"
    }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.prathibha.id
    tags = {
      Name = "igw"
    }  
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.prathibha.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
resource "aws_route_table_association" "rt" {
  subnet_id = aws_subnet.subnet1.id
  route_table_id = aws_route_table.public.id
  
}
resource "aws_security_group" "mysg" {
  name = "mysg"
  vpc_id = aws_vpc.prathibha.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "myins" {
  ami = "ami-0ebfd941bbafe70c6"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet1.id
  key_name = "vidya"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  associate_public_ip_address = true
  tags ={
    Name = "myins"
  }

}
output "instance_id" {
  value = aws_instance.myins.id
}