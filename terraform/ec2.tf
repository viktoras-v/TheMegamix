# Create key pair
resource "aws_key_pair" "megamix_key" {
  key_name   = "megamix_key"
  public_key = file("./id_ed25519.pub")
}

# Create EC2 Bastion
resource "aws_instance" "bastion" {
  ami           = "ami-01f79b1e4a5c64257"
  instance_type = "t2.micro"
  key_name      = "megamix_key"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.control_role.name
  user_data            = file("cloud-init.yaml")
  tags = {
    Name = "MegamixEC2Bastion"
  }
}

# IAM role for SSM
resource "aws_iam_role" "control_role" {
  name = "control-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# Assume role 
resource "aws_iam_instance_profile" "control_role" {
  name = "control-node-profile"
  role = aws_iam_role.control_role.name
}