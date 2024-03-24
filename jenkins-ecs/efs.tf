# Creating the EFS
resource "aws_efs_file_system" "efs" {
  creation_token = "${var.prefix}-efs"
  encrypted      = true

  tags = {
    Name = "${var.prefix}-efs"
  }
}

# Creating EFS mount targets in each public subnet
resource "aws_efs_mount_target" "storage" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.public_subnets.id
  security_groups = [aws_security_group.jenkins_efs.id]
}

# EFS access point
resource "aws_efs_access_point" "efs_ap" {
  file_system_id = aws_efs_file_system.efs.id

  # OS user and group applied to all file system requests made through this access point
  posix_user {
    uid = 0 # POSIX user ID
    gid = 0 # POSIX group ID
  }

  # The directory that this access point points to
  root_directory {
    path = "/var/jenkins_home"
    # POSIX user/group owner of this directory
    creation_info {
      owner_uid   = 1000 # Jenkins user
      owner_gid   = 1000 # Jenkins group
      permissions = "0755"
    }
  }

  tags = {
    Name = "${var.prefix}-efs-ap"
  }
}