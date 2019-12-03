module "aws_key_pair" {
  source     = "app.terraform.io/re-Invent/keypair/aws"
  key_name   = "reinvent-2019-key"
  public_key = "${var.ssh_public_key}"
}

module "aws_sg_hashicat" {
  source      = "app.terraform.io/re-Invent/securitygroup/aws"
  name        = "rhforum_sg_vault"
  description = "Used by Vault Server"
  vpc_id      = "${data.terraform_remote_state.base_layer.vpc_id}"

  custom_security_rules = [{
    "type"        = "egress"
    "from_port"   = "0"
    "to_port"     = "65535"
    "protocol"    = "-1"
    "description" = "Allow all"
    "cidr_blocks" = "0.0.0.0/0"
  },
    {
      "type"        = "ingress"
      "from_port"   = "22"
      "to_port"     = "22"
      "protocol"    = "tcp"
      "description" = "SSH Access to Hashicat"
      "cidr_blocks" = "0.0.0.0/0"
    },
    {
      "type"        = "ingress"
      "from_port"   = "443"
      "to_port"     = "443"
      "protocol"    = "tcp"
      "description" = "HTTPS Access to Hahsicat"
      "cidr_blocks" = "0.0.0.0/0"
    },
    {
      "type"        = "ingress"
      "from_port"   = "80"
      "to_port"     = "80"
      "protocol"    = "tcp"
      "description" = "HTTP Access to Hahsicat"
      "cidr_blocks" = "0.0.0.0/0"
    },
  ]
}

module "aws_instance_hashicat" {
  source = "app.terraform.io/re-Invent/instance/aws"
  ami    = "${data.aws_ami.ami.id}"

  instance_tags = {
    "Name" = "hashicat"
  }

  vm_count                    = "1"
  vpc_security_group_ids      = ["${module.aws_sg_hashicat.sg_id}"]
  subnet_id                   = "${data.terraform_remote_state.base_layer.public_subnets[0]}"
  key_name                    = "${module.aws_key_pair.key_name}"
  associate_public_ip_address = true
}

module "aws_record_hashicat" {
  source        = "app.terraform.io/re-Invent/route53-records/aws"
  zone_id       = "${data.terraform_remote_state.base_layer.dns_zone_id[0]}"
  instance_name = ["hashicat"]
  instance_ip   = ["${module.aws_instance_hashicat.instance_public_ip}"]
  record_type   = "A"
  record_ttl    = "300"
}
