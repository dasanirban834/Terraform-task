# Creating 3 EC2 Instances:

resource "aws_instance" "instance" {
  count           = length(aws_subnet.public_subnet.*.id)
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = element(aws_subnet.public_subnet.*.id, count.index)
  security_groups = [aws_security_group.sg.id, ]
  key_name        = "Keypair-01"
  iam_instance_profile = "${data.aws_iam_role.iam_role.name}"

  tags = {
    "Name"        = "Instance-${count.index}"
    "Environment" = "Test"
    "CreatedBy"   = "Terraform"
  }
  
  provisioner "file" {
    source = "~/.ssh/id_rsa.pub"
    destination  = "/home/ansible/.ssh/id_rsa.pub"
}

  connection {
    host        = "${element(self.*.public_ip, count.index)}"
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.pvt_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "useradd ansible",
      "echo 'ansible' | passwd  --stdin ansible",
    ]
  }

  provisioner "local-exec" {
    command    = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook httpd.yml -i aws_ec2.yml --private-key ~/.ssh/id_rsa"
    on_failure = continue
  }
}


# Creating 3 Elastic IPs:

resource "aws_eip" "eip" {
  count            = length(aws_instance.instance.*.id)
  instance         = element(aws_instance.instance.*.id, count.index)
  public_ipv4_pool = "amazon"
  vpc              = true

  tags = {
    "Name" = "EIP-${count.index}"
  }
}

# Creating EIP association with EC2 Instances:

resource "aws_eip_association" "eip_association" {
  count         = length(aws_eip.eip)
  instance_id   = element(aws_instance.instance.*.id, count.index)
  allocation_id = element(aws_eip.eip.*.id, count.index)
}
