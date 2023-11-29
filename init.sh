#!/bin/bash

# first init
if [ ! -f /var/flag_initial_setup_done ]; then
    # add user
    useradd -u $1 -ms /bin/bash $2
    echo "$2:$3" | chpasswd
    usermod -a -G sudo $2

    # install Miniforge
    sudo -u $2 bash /Miniforge3-Linux-x86_64.sh -b
    sudo -u $2 /home/$2/miniforge3/bin/conda init
    sudo -u $2 /home/$2/miniforge3/bin/mamba init
    rm /Miniforge3-Linux-x86_64.sh

    # mark as done
    touch /var/flag_initial_setup_done
fi

# normal start
/etc/init.d/ssh start
/bin/bash
