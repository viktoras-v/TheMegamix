# Create key pair
resource "aws_key_pair" "megamix_key" {
  key_name   = "megamix_key"
  public_key = file("../id_ed25519.pub")
}


# Create EC2 MySql
resource "aws_instance" "db" {
  ami           = "ami-01f79b1e4a5c64257"
  instance_type = "t2.micro"
  key_name      = "megamix_key"
  vpc_security_group_ids = [aws_security_group.sg-db.id]
  subnet_id = aws_subnet.private_subnet.id
  associate_public_ip_address = false
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  tags = {
    Name = "db"
  }
}

resource "aws_iam_role" "ssm_role" {
  name = "ec2_ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm_profile"
  role = aws_iam_role.ssm_role.name
}