output "instance" {
  value = aws_instance.this
}

output "public_ip" {
  value = aws_eip.this.public_ip
}
