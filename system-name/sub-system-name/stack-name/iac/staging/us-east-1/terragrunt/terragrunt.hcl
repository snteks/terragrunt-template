include "provider" {
  path   = find_in_parent_folders("./.global/iac/provider.hcl")
  expose = "true"
}

include "remote_state" {
  path   = find_in_parent_folders("./.global/iac/remote_state.hcl")
  expose = "true"
}

locals {
  context = yamldecode(include.provider.generate.context.contents)
  path    = find_in_parent_folders("./modules")
}


terraform {
  source = "${local.path}"
}


inputs = {
  context                = local.context
  ami_owner_id           = "099720109477"
  ami_name               = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20240927"
  server_list            = ["server1","server2","server3","server4","server5"]
  availability_zone      = "us-east-1a"
  iam_instance_profile   = "HIDS-EC2-Automation"
  instance_type          = "t3.large"
  key_name               = ""
  vpc_id                 = "vpc-18d5be7d"
  subnet_id              = "subnet-4f6b052a"
  mgt_subnet_id          = "subnet-5f09bd06"
  default_security_group = "sg-3d508959"
  gha_runner_pat         = "/cicd/runnerSelfHosted/vm/iac/github_org_pat"
  root_block_device = [{
    device_name = "/dev/sda1"
    volume_type = "gp3"
    volume_size = 200
    encrypted   = true
  }]
  ebs_block_device = [{
    device_name = "/dev/sdb"
    volume_type = "gp3"
    volume_size = 200
    encrypted   = true
  }]
}


