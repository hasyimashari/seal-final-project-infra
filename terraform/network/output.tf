output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_sub_1.id, aws_subnet.public_sub_2.id]
}

output "private_subnet_ids" {
  value = [aws_subnet.private_sub_1.id, aws_subnet.private_sub_2.id]
}