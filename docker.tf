provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "us-west-2"
}

resource "aws_security_group" "FESG" {
  name = "fesgtf"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
}

resource "aws_instance" "wordpressfrontend" {
  ami             = "ami-0747e613a2a1ff483"
  instance_type   = "t2.micro"
  key_name        = "admin"
  security_groups = [aws_security_group.FESG.name]
  tags = {
    app  = "wordpress"
    role = "frontend"
  }
}

resource "aws_eip" "wpip" {
  instance = aws_instance.wordpressfrontend.id
  vpc      = true
  tags = {
    app = "wordpress"
  }
}

resource "aws_db_instance" "wordpressbackend" {
  instance_class      = "db.t2.micro"
  engine              = "mysql"
  publicly_accessible = false
  allocated_storage   = 20
  name                = "wordpress"
  username            = "admin"
  password            = "adminpwd123"
  skip_final_snapshot = true
  tags = {
    app = "mysql"
  }
}

resource "null_resource" "configweb12" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/home/avijit69/Desktop/Projects/Terraform/admin.pem")
    host        = aws_instance.wordpressfrontend.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install docker -y",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo docker run -p 80:80 -d wordpress:latest"
    ]
  }
}

resource "null_resource" "configphp" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/home/avijit69/Desktop/Projects/Terraform/admin.pem")
    host        = aws_instance.wordpressfrontend.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y amazon-linux-extras",
      "sudo amazon-linux-extras enable php7.2",
      "sudo yum clean metadata -y",
      "sudo yum install php-cli php-pdo php-fpm php-json php-mysqlnd -y",
      "sudo systemctl restart httpd"
    ]
  }
}

output "WebServerIP" {
  value       = aws_instance.wordpressfrontend.public_ip
  description = "Web Server IP Address"
}

output "DatabaseName" {
  value       = aws_db_instance.wordpressbackend.name
  description = "The Database Name!"
}


resource "null_resource" "configdocker" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/home/avijit69/Desktop/Projects/Terraform/admin.pem")
    host        = aws_instance.wordpressfrontend.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo docker run -p 80:80 -d wordpress:latest"
    ]
  }
}

resource "aws_eip_association" "wpip_assoc" {
  instance_id   = aws_instance.wordpressfrontend.id
  allocation_id = aws_eip.wpip.id
}

output "DatabaseUserName" {
  value       = aws_db_instance.wordpressbackend.username
  description = "The Database Name!"
}

output "DBConnectionString" {
  value       = aws_db_instance.wordpressbackend.endpoint
  description = "The Database connection String!"
}

output "ElasticIP" {
  value       = aws_eip.wpip.public_ip
  description = "Elastic IP of the EC2 instance"
}

output "WordpressURL" {
  value       = "http://${aws_eip.wpip.public_ip}/"
  description = "URL for the deployed Wordpress site"
}


