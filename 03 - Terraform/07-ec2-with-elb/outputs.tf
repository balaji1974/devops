output "aws_security_group_http_server_details" {
  value = aws_security_group.elb_secgroup
}

output "http_server_public_dns" {
  value = values(aws_instance.my_ec2_http_servers).*.id
}

output "elb_public_dns" {
  value = aws_elb.elb
}
 
