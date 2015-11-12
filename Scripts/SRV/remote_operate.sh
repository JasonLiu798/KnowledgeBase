#!/bin/bash

if [ ! -d /root/.ssh ];then 
mkdir /root/.ssh
fi
cat /tmp/authorized_keys >> /root/.ssh/authorized_keys
