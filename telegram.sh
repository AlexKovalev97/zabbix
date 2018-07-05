#!/bin/bash
token='618362520:AAEkjr5-31xHNhwP62t9_WGDQiNWII3oCDM'
chat="$1"
subj="$2"
message="$3"
/usr/bin/curl -s --header 'Content-Type: application/json' --request 'POST' --data "{\"chat_id\":\"${chat}\",\"text\":\"${subj}\n${message}\"}" "https://api.telegram.org/bot${token}/sendMessage"
