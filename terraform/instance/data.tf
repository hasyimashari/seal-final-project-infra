data "aws_ssm_parameter" "amazon_linux2_ami_amd64" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_ssm_parameter" "amazon_linux2_ami_arm64" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-arm64-gp2"
}

data "template_file" "user_data_web_server" {
  template = <<-EOF
    #!/bin/bash
    yum update -y

    amazon-linux-extras install docker -y
    yum install -y wget tar

    service docker start
    usermod -a -G docker ec2-user

    systemctl enable docker

    cd /tmp
    wget https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz

    tar xvfz node_exporter-1.8.1.linux-amd64.tar.gz
    mv node_exporter-1.8.1.linux-amd64/node_exporter /usr/local/bin/

    groupadd --system node_exporter

    useradd --system -s /sbin/nologin -g node_exporter node_exporter

    cat <<EOT | tee /etc/systemd/system/node-exporter.service
    [Unit]
    Description=Prometheus Node Exporter
    Wants=network-online.target
    After=network-online.target

    [Service]
    User=node_exporter
    Group=node_exporter
    Type=simple
    ExecStart=/usr/local/bin/node_exporter
    Restart=always

    [Install]
    WantedBy=multi-user.target
    EOT

    systemctl daemon-reload
    systemctl enable --now node-exporter.service

    docker pull adhamfaraitodi/temansoal:1.0.0
    docker run -itd -p 80:3000 adhamfaraitodi/temansoal:1.0.0
  EOF
}

data "template_file" "user_data_monitoring_server" {
  template = <<-EOF
    #!/bin/bash
    yum update -y

    yum install -y wget tar

    cd /tmp
    wget https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-arm64.tar.gz

    tar xvfz node_exporter-1.8.1.linux-amd64.tar.gz
    mv node_exporter-1.8.1.linux-amd64/node_exporter /usr/local/bin/

    groupadd --system node_exporter

    useradd --system -s /sbin/nologin -g node_exporter node_exporter

    cat <<EOT | tee /etc/systemd/system/node-exporter.service
    [Unit]
    Description=Prometheus Node Exporter
    Wants=network-online.target
    After=network-online.target

    [Service]
    User=node_exporter
    Group=node_exporter
    Type=simple
    ExecStart=/usr/local/bin/node_exporter
    Restart=always

    [Install]
    WantedBy=multi-user.target
    EOT

    systemctl daemon-reload
    systemctl enable --now node-exporter.service
  EOF
}
