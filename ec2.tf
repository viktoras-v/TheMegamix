# Create EC2
resource "aws_instance" "example" {
  ami           = "ami-01f79b1e4a5c64257"
  instance_type = "t2.micro"
  key_name      = "MyKeyPair"     

  vpc_security_group_ids = [aws_security_group.devops_sg.id]
  subnet_id = aws_subnet.public.id


  associate_public_ip_address = true

  tags = {
    Name = "MyTerraformInstance"
  }
}