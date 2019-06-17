#!/bin/bash
IN="owaism;ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDqt769WhMOK2WrGpV5yG+yUUcxH8+cQSNM1PzVbHnFKFG9yNkFcSxD2gfWwk7QHfWL75Ox4HI3AcaSVALBL2Z/di290LgbTteROTrxQ+rrp/5EK3I43dsPwtu+N8Jknmj95w+LGl6BnubshDgv3GrKNBaxeZxZS42LlEub9naSL6uS0OjfgKn776yDj4635St0BmILjYxFR2uPLNBsAIyO0srtbaX5ZdYdNEazTsovI7vLkwX1gWusNVOs7GHZQZr1gpfBo/dEsz+yxKlioNCzH6PQkZ5ruI3UzFR2Hapxu2tppp1/7hgNF7I0cskIFF7ZDREtikqgArf7PWl6Wj3EDVnTPsnwVUvdtqRC0664wLku46QbQKcZagwhhwgC9rD9zpe3G6oTFR5rzJjIRuF7zQRoHcjumjv3q5FhiU/TeFfQHdAn5K64N4DvsKUdHlT9/Cp9rHc5ifEZi7w8nTal22QJ6TkK9LNLo/7zg+YZgq69LQVMUe6arcnbtDH1aJUjVfZwCrWh+TVVrFqHhQLgX9qk22GoNtgpXkdiIE+0hb1TMHXM6asebjGsoQ785+/WbTue3Ke343Km2P1SVOB/oZ2eBrw1kxa3Q7bpepXQXlhztBwek3gcSXxn+s5R4r09v7VP28XBA25U8jihzw0bgJhnojh+6UXW4QjghQsF6w== owais@OwaisM-Macbook-Pro,mario;ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEApyCrmPnuGWW5aDGAilsjFetZbeQ5wxamPIkcRnF16W61Ls8ZNrwaKytkeVB1a3fFaWGJMv0wNYmDvFR3I/z/YYYMx/maF7nG2ap1vGvUPlbYMXCZpFynY/TrljYMQmynOWty/cNNAagnxDrDDb3rHx/jdiNjQ7PPYPZ4QI1B/zqM3+ngf7nBXircknvgfZai/Tgae7BynFEgC8XHSHHmKn3/4TWkpNHJsCvrbK5tXa8PArPHDLA8aSYoogVV7Vh7Ff5xL+rYAoCWD/9Yq6Gd1lP9gReQvL2DhAmCpjWGGPc8lv0FdbyUOa9XNFSDHAJq1ZDIktEgyi/HNxw5nDbRcw== rsa-key-20190614"


IFS=',' read -r -a user_data_arr <<< "$IN"


for user_data in "${user_data_arr[@]}"
do
    
    IFS=';' read -r -a user_arr <<< "$user_data"

    username=${user_arr[0]}
    ssh_pub_key=${user_arr[1]}

    adduser --disabled-password --gecos "" $username

    mkdir /home/$username/.ssh
    touch /home/$username/.ssh/authorized_keys

    sudo chown -R $username:$username /home/$username/.ssh
	sudo chmod 0700 /home/$username/.ssh
	sudo chmod 0600 /home/$username/.ssh/authorized_keys

	echo $ssh_pub_key >> /home/$username/.ssh/authorized_keys
done