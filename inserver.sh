#!/bin/bash
yum install -y -q vim net-tools
yum install -y -q mariadb mariadb-server
/usr/bin/mysql_install_db --user=mysql
systemctl start mariadb 
sleep 10
mysql -uroot -e "create database zabbix character set utf8 collate utf8_bin"
mysql -uroot -e "grant all privileges on zabbix.* to zabbix@localhost identified by '1qaz2wsx';" 

yum install -y -q http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm
yum install -y -q zabbix-server-mysql zabbix-web-mysql
zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -uzabbix -p1qaz2wsx zabbix
printf "\nDBPassword=1qaz2wsx" >> /etc/zabbix/zabbix_server.conf 
systemctl start zabbix-server 

sed -i 's!# php_value date.timezone Europe/Riga!php_value date.timezone Europe/Minsk!g' /etc/httpd/conf.d/zabbix.conf
touch /etc/httpd/conf.d/vhost.conf
tee /etc/httpd/conf.d/vhost.conf << EOF
<VirtualHost *:80>
DocumentRoot /usr/share/zabbix
ServerName 10.0.0.10
</VirtualHost>
EOF
systemctl start httpd 

yum install -y -q zabbix-agent
sed -i 's/ServerActive/#ServerActive/g' /etc/zabbix/zabbix_agentd.conf
systemctl start zabbix-agent