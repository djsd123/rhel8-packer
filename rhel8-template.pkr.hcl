locals {
  timestamp = regex_replace(timestamp(), "[ TZ:]", "")
}

data amazon-ami "amz_rhel_8" {

  filters = {
    name                = "RHEL_HA-8.4.*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }

  most_recent = true
  owners      = ["309956199498"]
}

#data amazon-ami "amz_linux" {
#
#  filters = {
#    name                = "amzn2-ami-hvm-2.*"
#    root-device-type    = "ebs"
#    virtualization-type = "hvm"
#  }
#
#  most_recent = true
#  owners      = ["137112412989"]
#}

source "amazon-ebs" "rhel_8" {
  skip_create_ami = var.run_test_build
  ami_name        = "${var.ami_name}-${local.timestamp}-${uuidv4()}"
  ami_description = "${var.ami_name} rhel 8 (x86_64)"
  ami_regions     = [var.region]
  #  ami_users               = var.allowed_account_ids
  ami_virtualization_type = "hvm"
  ena_support             = true
  sriov_support           = true # Requires ens set to true.  HVM compatible only
  #  encrypt_boot = true
  #  kms_key_id = var.kms_key_arn
  instance_type = var.instance_type
  region        = var.region
  source_ami    = data.amazon-ami.amz_rhel_8.id

  temporary_iam_instance_profile_policy_document {
    Version = "2012-10-17"
    Statement {
      Effect = "Allow"

      Action = [
        "ec2:*",
        "ssm:*"
      ]

      Resource = ["*"]
    }
  }

  run_tags = {
    Name = "Packer rhel 8 Builder (x86_64) ${local.timestamp}"
  }

  run_volume_tags = {
    Name = "Packer rhel 8 Builder ${local.timestamp}"
  }

  communicator = "ssh"
  ssh_pty      = true
  ssh_username = "ec2-user"
  ssh_timeout  = "5m"
  #  ssh_interface        = "session_manager" # Requires SSM Agent to exist
  pause_before_ssm = "30m"

  user_data_file = "userdata.yaml"

  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    delete_on_termination = true
    volume_size           = 20
    volume_type           = "gp3"
  }

  tags = {
    Name          = "${var.ami_name} (x86_64)"
    OS_Version    = "rhel 8"
    Release       = "Latest"
    Base_AMI_Name = "{{ .SourceAMIName }}"
    Created       = local.timestamp
  }

  aws_polling {
    delay_seconds = 30
    max_attempts  = 100
  }
}

build {
  sources = ["source.amazon-ebs.rhel_8"]

  provisioner "shell" {
    remote_folder = "/home/ec2-user"

    script          = "assets/provision.sh"
    execute_command = "sudo -S env {{ .Vars }} {{ .Path }}"
  }
}
