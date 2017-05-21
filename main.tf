provider "aws" {
  shared_credentials_file = ".aws_creds"
  region     = "us-west-2"
}

#create the Chef Servers
resource "aws_instance" "chefserver" {
  count = "${var.studentCount}"
  ami           = "${var.ami}"
  instance_type = "${var.chefServerInstanceType}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = "${var.securityGroups}"
  provisioner "local-exec" {
    command = "./update_dns.rb \"${element(var.cardTable, count.index)}.chefserver\" \"${self.public_ip}\""
  }
  provisioner "file" {
    source      = "./cookbooks"
    destination = "/tmp/cookbooks"
  }
  provisioner "remote-exec" {
    inline    = [
      "sudo hostnamectl set-hostname ${element(var.cardTable, count.index)}.chefserver.e9.io",
      "sudo /usr/bin/yum -y install wget",
      "sudo /bin/wget https://packages.chef.io/files/stable/chefdk/1.3.43/el/7/chefdk-1.3.43-1.el7.x86_64.rpm -O /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/rpm -Uv /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/chef-solo -c /tmp/cookbooks/solo.rb -o recipe[automate_lab],recipe[automate_lab::chef_server]"
    ]
  }
  connection {
    type     = "ssh"
    user     = "centos"
    private_key = "${file("${var.key_path}")}"
  }
  tags {
    Name = "${element(var.cardTable, count.index)}.chefserver.e9.io",
    X-Contact = "tcate@chef.io",
    X-Dept = "Customer Success"
  }
}

#create the Chef Automate Servers
resource "aws_instance" "automate" {
  count = "${var.studentCount}"
  ami           = "${var.ami}"
  instance_type = "${var.automateInstanceType}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = "${var.securityGroups}"
  provisioner "local-exec" {
    command = "./update_dns.rb \"${element(var.cardTable, count.index)}.automate\" \"${self.public_ip}\""
  }
  provisioner "file" {
    source      = "./cookbooks"
    destination = "/tmp/cookbooks"
  }
  provisioner "remote-exec" {
    inline    = [
      "sudo hostnamectl set-hostname ${element(var.cardTable, count.index)}.automate.e9.io",
      "sudo /usr/bin/yum -y install wget",
      "sudo /bin/wget https://packages.chef.io/files/stable/chefdk/1.3.43/el/7/chefdk-1.3.43-1.el7.x86_64.rpm -O /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/rpm -Uv /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/chef-solo -c /tmp/cookbooks/solo.rb -o recipe[automate_lab],recipe[automate_lab::automate]"
    ]
  }
  connection {
    type     = "ssh"
    user     = "centos"
    private_key = "${file("${var.key_path}")}"
  }
  tags {
    Name = "${element(var.cardTable, count.index)}.automate.e9.io",
    X-Contact = "tcate@chef.io",
    X-Dept = "Customer Success"
  }
}

##create the Chef Runners
resource "aws_instance" "runner" {
  count = "${var.studentCount}"
  ami           = "${var.ami}"
  instance_type = "${var.runnerInstanceType}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = "${var.securityGroups}"
  provisioner "local-exec" {
    command = "./update_dns.rb \"${element(var.cardTable, count.index)}.runner\" \"${self.public_ip}\""
  }
  provisioner "file" {
    source      = "./cookbooks"
    destination = "/tmp/cookbooks"
  }
  provisioner "remote-exec" {
    inline    = [
      "sudo hostnamectl set-hostname ${element(var.cardTable, count.index)}.runner.e9.io",
      "sudo /usr/bin/yum -y install wget",
      "sudo /bin/wget https://packages.chef.io/files/stable/chefdk/1.3.43/el/7/chefdk-1.3.43-1.el7.x86_64.rpm -O /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/rpm -Uv /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/chef-solo -c /tmp/cookbooks/solo.rb -o recipe[automate_lab]"
    ]
  }
  connection {
    type     = "ssh"
    user     = "centos"
    private_key = "${file("${var.key_path}")}"
  }
  tags {
    Name = "${element(var.cardTable, count.index)}.runner.e9.io",
    X-Contact = "tcate@chef.io",
    X-Dept = "Customer Success"
  }
}

##create the Chef Infra Nodes
resource "aws_instance" "infranode" {
  count = "${var.studentCount}"
  ami           = "${var.ami}"
  instance_type = "${var.runnerInstanceType}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = "${var.securityGroups}"
  provisioner "local-exec" {
    command = "./update_dns.rb \"${element(var.cardTable, count.index)}.infranode\" \"${self.public_ip}\""
  }
  provisioner "file" {
    source      = "./cookbooks"
    destination = "/tmp/cookbooks"
  }
  provisioner "remote-exec" {
    inline    = [
      "sudo hostnamectl set-hostname ${element(var.cardTable, count.index)}.infranode.e9.io",
      "sudo /usr/bin/yum -y install wget",
      "sudo /bin/wget https://packages.chef.io/files/stable/chefdk/1.3.43/el/7/chefdk-1.3.43-1.el7.x86_64.rpm -O /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/rpm -Uv /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/chef-solo -c /tmp/cookbooks/solo.rb -o recipe[automate_lab]"
    ]
  }
  connection {
    type     = "ssh"
    user     = "centos"
    private_key = "${file("${var.key_path}")}"
  }
  tags {
    Name = "${element(var.cardTable, count.index)}.infranode.e9.io",
    X-Contact = "tcate@chef.io",
    X-Dept = "Customer Success"
  }
}

#create the Demo Chef Server
resource "aws_instance" "demo_chefserver" {
  ami           = "${var.ami}"
  instance_type = "${var.chefServerInstanceType}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = "${var.securityGroups}"
  provisioner "local-exec" {
    command = "./update_dns.rb \"demo.chefserver\" \"${self.public_ip}\""
  }
  provisioner "file" {
    source      = "./cookbooks"
    destination = "/tmp/cookbooks"
  }
  provisioner "remote-exec" {
    inline    = [
      "sudo hostnamectl set-hostname demo.chefserver.e9.io",
      "sudo /usr/bin/yum -y install wget",
      "sudo /bin/wget https://packages.chef.io/files/stable/chefdk/1.3.43/el/7/chefdk-1.3.43-1.el7.x86_64.rpm -O /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/rpm -Uv /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/chef-solo -c /tmp/cookbooks/solo.rb -o recipe[automate_lab],recipe[automate_lab::demo_server]"
    ]
  }
  connection {
    type     = "ssh"
    user     = "centos"
    private_key = "${file("${var.key_path}")}"
  }
  tags {
    Name = "demo.chefserver.e9.io",
    X-Contact = "tcate@chef.io",
    X-Dept = "Customer Success"
  }
}

#create the Demo Automate Server
resource "aws_instance" "demo_automateserver" {
  ami           = "${var.ami}"
  instance_type = "${var.automateInstanceType}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = "${var.securityGroups}"
  provisioner "local-exec" {
    command = "./update_dns.rb \"demo.automate\" \"${self.public_ip}\""
  }
  provisioner "file" {
    source      = "./cookbooks"
    destination = "/tmp/cookbooks"
  }
  provisioner "remote-exec" {
    inline    = [
      "sudo hostnamectl set-hostname demo.automate.e9.io",
      "sudo /usr/bin/yum -y install wget",
      "sudo /bin/wget https://packages.chef.io/files/stable/chefdk/1.3.43/el/7/chefdk-1.3.43-1.el7.x86_64.rpm -O /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/rpm -Uv /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/chef-solo -c /tmp/cookbooks/solo.rb -o recipe[automate_lab],recipe[automate_lab::demo_automate]"
    ]
  }
  connection {
    type     = "ssh"
    user     = "centos"
    private_key = "${file("${var.key_path}")}"
  }
  tags {
    Name = "demo.automate.e9.io",
    X-Contact = "tcate@chef.io",
    X-Dept = "Customer Success"
  }
  depends_on = [
    "aws_instance.demo_runner",
    "aws_instance.demo_chefserver"
  ]
}

#create the Demo Runner Servers
resource "aws_instance" "demo_runner" {
  ami           = "${var.ami}"
  count         = 2
  instance_type = "${var.runnerInstanceType}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = "${var.securityGroups}"
  provisioner "local-exec" {
    command = "./update_dns.rb \"demo.runner${count.index}\" \"${self.public_ip}\""
  }
  provisioner "file" {
    source      = "./cookbooks"
    destination = "/tmp/cookbooks"
  }
  provisioner "remote-exec" {
    inline    = [
      "sudo hostnamectl set-hostname demo.runner${count.index}.e9.io",
      "sudo /usr/bin/yum -y install wget",
      "sudo /bin/wget https://packages.chef.io/files/stable/chefdk/1.3.43/el/7/chefdk-1.3.43-1.el7.x86_64.rpm -O /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/rpm -Uv /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/chef-solo -c /tmp/cookbooks/solo.rb -o recipe[automate_lab]"
    ]
  }
  connection {
    type     = "ssh"
    user     = "centos"
    private_key = "${file("${var.key_path}")}"
  }
  tags {
    Name = "demo.runner${count.index}.e9.io",
    X-Contact = "tcate@chef.io",
    X-Dept = "Customer Success"
  }
}

#create the Demo Infra Servers
resource "aws_instance" "demo_infra" {
  ami           = "${var.ami}"
  count         = 2
  instance_type = "${var.runnerInstanceType}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = "${var.securityGroups}"
  provisioner "local-exec" {
    command = "./update_dns.rb \"demo.infra${count.index}\" \"${self.public_ip}\""
  }
  provisioner "file" {
    source      = "./cookbooks"
    destination = "/tmp/cookbooks"
  }
  provisioner "remote-exec" {
    inline    = [
      "sudo hostnamectl set-hostname demo.infra${count.index}.e9.io",
      "sudo /usr/bin/yum -y install wget",
      "sudo /bin/wget https://packages.chef.io/files/stable/chefdk/1.3.43/el/7/chefdk-1.3.43-1.el7.x86_64.rpm -O /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/rpm -Uv /tmp/chefdk-1.3.43-1.el7.x86_64.rpm",
      "sudo /bin/chef-solo -c /tmp/cookbooks/solo.rb -o recipe[automate_lab],recipe[automate_lab::demo_infra]"
    ]
  }
  connection {
    type     = "ssh"
    user     = "centos"
    private_key = "${file("${var.key_path}")}"
  }
  tags {
    Name = "demo.infra${count.index}.e9.io",
    X-Contact = "tcate@chef.io",
    X-Dept = "Customer Success"
  }
  depends_on = [
    "aws_instance.demo_chefserver"
  ]
}