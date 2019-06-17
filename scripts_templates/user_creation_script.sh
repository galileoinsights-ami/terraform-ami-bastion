#!/bin/bash
IN="${bastion_users}"


IFS=',' read -r -a user_data_arr <<< "$IN"


for user_data in "$${user_data_arr[@]}"
do
    
    IFS=';' read -r -a user_arr <<< "$user_data"

    username=$${user_arr[0]}
    ssh_pub_key=$${user_arr[1]}

    adduser --disabled-password --gecos "" $username

    mkdir /home/$username/.ssh
    touch /home/$username/.ssh/authorized_keys

    sudo chown -R $username:$username /home/$username/.ssh
	sudo chmod 0700 /home/$username/.ssh
	sudo chmod 0600 /home/$username/.ssh/authorized_keys

	echo $ssh_pub_key >> /home/$username/.ssh/authorized_keys
done