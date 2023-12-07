resource "aws_key_pair" "instance_key_pair" {
  key_name   = "${local.resource_prefix}-ssh-key-pair"
  public_key = file(var.ssh_public_key)

}


resource "aws_instance" "webserver_instance" {
  count                       = length(var.webserver_instance.names)
  key_name                    = aws_key_pair.instance_key_pair.key_name
  instance_type               = var.webserver_instance.type
  ami                         = var.webserver_instance.ami
  subnet_id                   = aws_subnet.subnet[count.index].id
  vpc_security_group_ids      = [aws_security_group.security_group.id]
  associate_public_ip_address = true

  user_data = <<EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl enable --now httpd

    echo "Response coming from ${var.webserver_instance.names[count.index]}" | sudo tee /var/www/html/index.html
  EOF

  tags = {
    Name = "${local.resource_prefix}-${var.webserver_instance.names[count.index]}"
  }

  depends_on = [
    aws_route_table_association.subnet_association
  ]
}
