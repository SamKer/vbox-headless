#!/bin/bash
#rename hostname
#give new IP

NEWHOSTNAME=$1
sudo sed -i "s/$HOSTNAME/$NEWHOSTNAME/g" /etc/hostname /etc/hosts
echo "NEW HOSTNAME DEFINED FOR  $NEWHOSTNAME"
exit 0	
