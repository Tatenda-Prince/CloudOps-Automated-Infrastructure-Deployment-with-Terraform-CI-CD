output "ec2_public_ip1" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "s3_bucket_tatenda" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.my_bucket.id
}

