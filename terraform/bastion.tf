
resource "aws_instance" "bastion_host" {
  ami = var.ami.amazon
  key_name = var.key_pairs.bastion
  instance_type = var.instance_type.amazon
  subnet_id = aws_subnet.pub0.id
  security_groups = [aws_security_group.bastion_sg.id]
}
resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion_host.id
  vpc      = true
}