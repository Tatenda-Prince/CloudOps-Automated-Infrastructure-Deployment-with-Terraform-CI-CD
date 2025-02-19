provider "aws" {
  region = "us-east-1"  # Change to your preferred AWS region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket ="ashley-my-terraform-ci-cd-bucket"
}

resource "random_id" "sg_suffix" {
  byte_length = 8  # Generate an 8-byte random string to append to the security group name
}

resource "aws_security_group" "ec2_sg1" {
  name        = "ec2_security_group_${random_id.sg_suffix.hex}"  # Use random suffix to ensure uniqueness
  description = "Allow inbound HTTP and SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere (change this for security)
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow Node.js app access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-053a45fff0a704a47"  # Amazon Linux 2 AMI (replace with latest)
  instance_type = "t2.micro"
  security_groups = [aws_security_group.ec2_sg1.name]  # Referencing the new security group with the unique name

  tags = {
    Name = "Node.jsWebServer"  # This tag will be visible in the AWS Console
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nodejs npm git
              
              # Create app directory
              mkdir -p /home/ec2-user/app
              cd /home/ec2-user/app
              
              # Create simple Node.js app
              echo "const http = require('http');" >> app.js
              echo "const server = http.createServer((req, res) => {" >> app.js
              echo "  res.statusCode = 200;" >> app.js
              echo "  res.setHeader('Content-Type', 'text/plain');" >> app.js
              echo "  res.end('Hello, Welcome to Up The Chelsea Tech!Terraform CI/CD!\n');" >> app.js
              echo "});" >> app.js
              echo "server.listen(3000, '0.0.0.0', () => {" >> app.js
              echo "  console.log('Server running on port 3000');" >> app.js
              echo "});" >> app.js
              
              # Install PM2 to keep the app running
              npm install -g pm2
              pm2 start app.js
              pm2 startup
              pm2 save
              EOF
}


output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

output "s3_bucket_name" {
  value = aws_s3_bucket.my_bucket.id
}
