#!/bin/bash
yum install -y -q http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm
yum install -y -q vim net-tools zabbix-agent

sed -i 's/Server=127.0.0.1/Server=10.0.0.10/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/ServerActive/#ServerActive/g' /etc/zabbix/zabbix_agentd.conf

systemctl start zabbix-agent