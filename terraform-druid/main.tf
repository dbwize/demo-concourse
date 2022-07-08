provider "aws" {
  region = "us-west-2"
}

provider "random" {}

resource "random_pet" "name" {}

resource "aws_instance" "web" {
  ami           = "ami-098e42ae54c764c35"
  instance_type = "t2.xlarge"
  user_data     = file("init-script.sh")
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name = aws_key_pair.deployer.key_name

  tags = {
    Name = random_pet.name.id
  }
}

resource "aws_security_group" "web-sg" {
  name = "${random_pet.name.id}-sg"
  ingress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "ssh-key1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDSPfu5lwRx6Wo7+wRfEcCpUKXmvu7l22HMO20vczkCN1d35t5yKZ9fHsqR9YGe801QAJdrBukYcKPic7VXaBsRmdq3JJteKupoPJy87oSMPbV95fnDmcT75Avf2qIkoN+Gr2nVtRawswf1gBTXXSv9NhwL++Hm9Ha/o02fgdjeoURphPwyP091Z4Q8UZWczULailKbO/UfviDqHPpGpnPIg+mMT6stKFt2F/jw1kmPmiHZSZAJ0AlbstzMEYTS++zauMqCi/2rRVhEH18VrXYZNT7XTbXeFlvJLqrYgDu96mJ50Cze2VqdiShSG07PDVBivLbRlWURHxtOQXfLsOdwkdcS/1VM6V6QuQqtMYoTGh5F8jsdOBbkBPG6SjmMkuPlKU2VWlTLAwzb8Az93cFaUDjzbqm6bLIOZrd1jax5x3J5o/qLcjrEC7nsMk1PZX6pHc34yTEhso4ivXvVSs/Fp4HvfDkQloe7NxRQ6S7IelDCF/7uJSNYCrB6v94Dsrc= dabenson@C02GQ0V81PG4"
}



