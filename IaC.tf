#--------------------------------------
#Made by Oleg Kurcheuski
#
#--------------------------------------
provider "aws" {
     region = "eu-central-1"
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.tf_Ubuntu2.id
}

resource "aws_instance" "tf_Ubuntu2" {
  ami = "ami-0b1deee75235aa4bb"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_web_server.id]
  user_data = templatefile("script.sh.tpl", {
    f_name= "Oleg",
    l_name= "Demidovich",
    names= ["Name1", "Name2", "Name3", "Name4"]
  })
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "WebServer"
    Owner = "ALEH"
  }
}

resource "aws_security_group" "my_web_server" {
  name        = "Dynamic_Security_Group"
  description = "Security group for webserver by terraform"
  dynamic "ingress" {
    for_each = ["80", "443", "8080", "1541"]
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Allow_Http"
  }
}


