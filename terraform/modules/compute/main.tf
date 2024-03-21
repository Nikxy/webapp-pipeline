resource "aws_launch_template" "deployment" {
  name                   = "webapp-deployment"
  image_id               = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.ec2.id]

  user_data = base64encode(<<-EOT
  #!/bin/bash -xe
  exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
  sudo yum update -y
  sudo yum -y install docker
  sudo service docker start
  sudo usermod -a -G docker ec2-user
  export DOCKER_CONTENT_TRUST=1
  sudo docker run --rm --name webapp -d -p 8000:8000 ${var.image_url}
  EOT
  )

  block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      volume_size           = 4
      delete_on_termination = true
    }
  }
  tag_specifications {
    resource_type = "instance"
    tags          = {
      Name = "${var.app_name}-deployment"
      Project = "webapp"
    }
  }
  tags = {
    Project = "webapp"
  }
}

resource "aws_autoscaling_group" "deployment" {
  vpc_zone_identifier = var.subnets
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1

  launch_template {
    id      = aws_launch_template.deployment.id
    version = "$Latest"
  }
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
  tag {
    key                 = "Project"
    value               = "webapp"
    propagate_at_launch = true
  }
  tag {
    key                 = "Image"
    value               = ${var.image_url}
    propagate_at_launch = true
  }
}



