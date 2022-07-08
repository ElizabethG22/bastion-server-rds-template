## Bastion EC2 Setup

- create an EC2 instance with Amazon Linux 2 OS
- give this role: `ec2-ssm-role`
- use the command to get access to its terminal:
```sh
aws ssm start-session --target <ec2-instance-id> --profile <name_of_profile> --region eu-west-1
```
- install [Session Manager plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#:~:text=plugin%20installation.-,Install%20Session%20Manager%20plugin%20on%20Linux,-Download%20the%20Session):
```sh
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl start amazon-ssm-agent
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o "session-manager-plugin.rpm"
sudo yum install -y session-manager-plugin.rpm
```
- verify the installation
```sh
session-manager-plugin --version
```

## DB setup

- Create a rds instance in a private subnet (do not check the public access checkbox)
- In it's security group let it to be connected by the previous EC2 instance (put it's IP in an inbound connection rule)

## Port Forwarding

- Make sure you have installed AWS CLI and Session Manager plugin for it in your local machine.
- Run the following command:
```sh
aws ssm start-session \
    --target <ec2-instance-id> \
    --profile <name_of_profile> \
    --document-name AWS-StartPortForwardingSessionToRemoteHost \
    --parameters '{"host":["<your-rds-db-endpoint>"],"portNumber":["<your-db-port-number>"], "localPortNumber":["<your-local-port-number>"]}'
    --region eu-west-1
```

## Temp

```sh
aws ssm start-session \
    --target i-0c2c2d336b81d0f90 \
    --profile default \
    --region eu-west-1 \
    --document-name AWS-StartPortForwardingSessionToRemoteHost \
    --parameters '{"host":["behnam-temp-default-db.cm76nv1fmnjs.eu-west-1.rds.amazonaws.com"],"portNumber":["5432"], "localPortNumber":["5433"]}'


aws ssm start-session --target i-0c2c2d336b81d0f90 --profile default --region eu-west-1


psql -h behnam-temp-default-db.cm76nv1fmnjs.eu-west-1.rds.amazonaws.com -p 5432 -U "meeseeks" -W -d personal



sudo tee /etc/yum.repos.d/pgdg.repo<<EOF
[pgdg14]
name=PostgreSQL 14 for RHEL/CentOS 7 - x86_64
baseurl=https://download.postgresql.org/pub/repos/yum/14/redhat/rhel-7-x86_64
enabled=1
gpgcheck=0
EOF


sudo yum makecache

sudo yum install postgresql14 postgresql14-server


sudo /usr/pgsql-14/bin/postgresql-14-setup initdb

sudo systemctl enable --now postgresql-14

systemctl status postgresql-14
```

```sh
sudo yum install telnet -y

telnet behnam-temp-default-db.cm76nv1fmnjs.eu-west-1.rds.amazonaws.com 5432
telnet thirstee.cm76nv1fmnjs.eu-west-1.rds.amazonaws.com 3306
```