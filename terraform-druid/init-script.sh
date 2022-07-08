#!/bin/bash
yum update -y
yum install -y wget vim curl java-1.8.0-openjdk
update-alternatives --set 'java' /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java
# yum -y remove httpd
# yum -y remove httpd-tools
# yum install -y httpd24 php72 mysql57-server php72-mysqlnd
# service httpd start
# chkconfig httpd on

# usermod -a -G apache ec2-user
# chown -R ec2-user:apache /var/www
# chmod 2775 /var/www
# find /var/www -type d -exec chmod 2775 {} \;
# find /var/www -type f -exec chmod 0664 {} \;
# cd /var/www/html
# curl http://169.254.169.254/latest/meta-data/instance-id -o index.html
# curl https://raw.githubusercontent.com/hashicorp/learn-terramino/master/index.php -O

wget https://dlcdn.apache.org/druid/0.23.0/apache-druid-0.23.0-bin.tar.gz
tar -xzf apache-druid-0.23.0-bin.tar.gz
### TODO: 
# do the systemd approach to start the druid service on this ec2
# deploy both confluent and druid with concourse job(Confluent will host kafka, daniel's aws account will host the ec2 with druid)
# Test a kafka stream connection from confluent over to druid
# See how we can then deploy everything with terraform and with concourse
# cd apache-druid-0.23.0
# ./bin/start-micro-quickstart &

# Creation of systemd service for druid 

cat > /etc/systemd/system/druid.service << EOF
[Unit]
Description=Druid server daemon
After=network.target
[Service]
User=root
Group=root
Type=simple
ExecStart=/apache-druid-0.23.0/bin/start-micro-quickstart
Restart=always
RestartSec=5s
PrivateTmp=true
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable druid.service
systemctl start druid.service