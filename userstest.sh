#!/bin/bash

read $PASS
for i in `more ~/Desktop/users.txt `
do
echo $i
if [ "$(grep -c $i /etc/passwd)" == 1 ]; then
    echo '  User Exists'
else
    echo 'User does not exist, adding now...'
    sudo useradd -p $(openssl passwd -1 $PASS) $i
fi
done