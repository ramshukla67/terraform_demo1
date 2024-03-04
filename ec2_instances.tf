resource "aws_instance" "ec2_instance_1" {
  ami           = "ami-052c9ea013e6e3567"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx docker.io
              EOF

  tags = {
    Name = "EC2Instance1"
  }
}

resource "aws_instance" "ec2_instance_2" {
  ami           = "ami-052c9ea013e6e3567"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_2.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx docker.io
              EOF

  tags = {
    Name = "EC2Instance2"
  }
}
