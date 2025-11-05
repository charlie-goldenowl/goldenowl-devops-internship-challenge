#!/bin/bash
set -e

# Update system
yum update -y

# Install Docker
yum install -y docker unzip
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf aws awscliv2.zip

# Configure Docker logging
mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<DOCKERCONF
{
  "log-driver": "awslogs",
  "log-opts": {
    "awslogs-region": "${aws_region}",
    "awslogs-group": "${log_group_name}"
  }
}
DOCKERCONF
systemctl restart docker

# Login to ECR and pull image
aws ecr get-login-password --region ${aws_region} | docker login --username AWS --password-stdin ${ecr_repository_url}

# Create systemd service
cat > /etc/systemd/system/golden-owl.service <<SERVICECONF
[Unit]
Description=Golden Owl Application
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker stop golden-owl-app
ExecStartPre=-/usr/bin/docker rm golden-owl-app
ExecStartPre=/usr/bin/docker pull ${ecr_repository_url}:latest
ExecStart=/usr/bin/docker run --rm --name golden-owl-app -p 3000:3000 ${ecr_repository_url}:latest

[Install]
WantedBy=multi-user.target
SERVICECONF

# Start service
systemctl daemon-reload
systemctl enable golden-owl.service
systemctl start golden-owl.service

echo "EC2 instance setup complete!"
