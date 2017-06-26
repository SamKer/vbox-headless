#!/bin/bash
#new user
NEWUSER=$1
KEY="$2"
sudo useradd $NEWUSER --create-home
sudo touch "/etc/sudoers.d/$NEWUSER"
sudo sh -c "echo '$NEWUSER\tALL=(ALL)\tNOPASSWD:ALL' > /etc/sudoers.d/$NEWUSER"
sudo mkdir "/home/$NEWUSER/.ssh/"
sudo touch "/home/$NEWUSER/.ssh/authorized_keys"
sudo sh -c "echo $KEY >> /home/$NEWUSER/.ssh/authorized_keys"
sudo chown $NEWUSER: -R "/home/$NEWUSER/.ssh/"
sudo chmod 644 -R "/home/$NEWUSER/.ssh/"
sudo chmod 600 -R "/home/$NEWUSER/.ssh/authorized_keys"	
echo "user added in vm"
exit 0	