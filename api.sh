#!/bin/bash

#authentication token
curl -d '{
			"jsonrpc": "2.0",
			"method": "user.login",
			"params": {"user":"Admin","password":"zabbix"},
			"id": 1
		}' -H "Content-Type: application/json-rpc" -X POST http://10.0.0.10/api_jsonrpc.php > /tmp/token.tmp
token=$(sed -e 's/^.*"result":"\([^"]*\)".*$/\1/' /tmp/token.tmp)

#Host Group
curl -d '{
			"jsonrpc": "2.0",
			"method": "hostgroup.get",
			"params": {"output": "extend","filter": {"name":"CloudHosts"}},
			"auth": "'$token'","id": 1
		}' -H "Content-Type: application/json-rpc" -X POST http://10.0.0.10/api_jsonrpc.php > /tmp/group.tmp

if ! grep 'CloudHosts' /tmp/group.tmp; 
  then
    curl -d '{
    			"jsonrpc": "2.0",
    			"method": "hostgroup.create",
    			"params": {"name":"CloudHosts"},
    			"auth": "'$token'",
    			"id": 1
    		}' -H "Content-Type: application/json-rpc" -X POST http://10.0.0.10/api_jsonrpc.php > /tmp/group.tmp
    group=$(sed -e 's/^.*"groupids":\["\([^"]*\)"\].*$/\1/' /tmp/group.tmp)
fi

#Custom template
curl -d '{
			"jsonrpc": "2.0",
			"method": "template.create",
			"params":{"host":"CustomTemplate",
			"groups": {"groupid": "'$group'"}},
			"auth": "'$token'",
			"id":1
		}' -H "Content-Type: application/json-rpc" -X POST http://10.0.0.10/api_jsonrpc.php > /tmp/template.tmp
template=$(sed -e 's/^.*"templateids":\["\([^"]*\)"\].*$/\1/' /tmp/template.tmp)

#Host
curl -d '{
			"jsonrpc": "2.0",
			"method": "host.create",
			"params":{
				"host":"Test",
				"interfaces": [{"type": 1,"main": 1,"useip": 1,"ip": "10.0.0.50","dns": "","port": "10050"}],
				"groups":[{"groupid": "'$group'"}],
				"templates": [{"templateid":"'$template'"}]},
			"auth": "'$token'",
			"id": 1
		}' -H "Content-Type: application/json-rpc" -X POST http://10.0.0.10/api_jsonrpc.php