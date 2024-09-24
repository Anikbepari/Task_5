provider "aws" {
  region = "us-east-1"
}

# Create EC2 instance
resource "aws_instance" "Anik_medusa" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.small"
  key_name      = "task_5"
  vpc_security_group_ids = [aws_security_group.Anik_medusa_security_group.id]
  
  root_block_device {
    volume_size = 30
  }

  # Connection to instance
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("C:/Users/abepa/Downloads/task_5.pem")
    host        = self.public_ip
  }

  # Upload the startup script
  provisioner "file" {
    source      = "C:/Users/abepa/Documents/Task5/startup_script.sh"
    destination = "/home/ubuntu/setup_script.sh"
  }

  # Execute the startup script remotely
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/setup_script.sh",
      "/home/ubuntu/setup_script.sh"
    ]
  }

  # Tag the instance
  tags = {
    Name = "Anik_medusa"
  }
}

# Create Security Group
resource "aws_security_group" "Anik_medusa_security_group" {
  name        = "allow_ssh_and_custom"
  description = "Allow SSH and inbound traffic on port 9000"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow inbound traffic on port 9000"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Anik-medusa-sec-group"
  }
}

# Output the public IP of the EC2 instance
output "instance_public_ip" {
  value = aws_instance.Anik_medusa.public_ip
}
