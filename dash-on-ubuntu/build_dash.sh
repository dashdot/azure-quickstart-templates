#!/bin/bash

set -e 

date
ps axjf

#############
# Parameters
#############

AZUREUSER=$1
HOMEDIR="/home/$AZUREUSER"
VMNAME=`hostname`
echo "User: $AZUREUSER"
echo "User home dir: $HOMEDIR"
echo "vmname: $VMNAME"

#####################
# Setup Dash
#####################

if [ $2 = 'From_Source' ]; then
###########################################################
# Update Ubuntu and install prerequisites for running Dash 
###########################################################
sudo apt-get update
###########################################################
# Build Dash from source                                   
###########################################################
NPROC=$(nproc)
echo "nproc: $NPROC"
###########################################################
# Install all necessary packages for building Dash         
###########################################################
sudo apt-get -y install git build-essential libtool autotools-dev autoconf pkg-config libssl-dev libevent-dev bsdmainutils libboost-all-dev libminiupnpc-dev libzmq3-dev
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

cd /usr/local
file=/usr/local/dash
if [ ! -e "$file" ]
then
	sudo git clone https://github.com/dashpay/dash.git
fi

cd /usr/local/dash
file=/usr/local/dash/src/dashd
if [ ! -e "$file" ]
then
	sudo ./autogen.sh
	sudo ./configure --prefix=/usr
	sudo make -j$NPROC
	sudo make install
fi

else    
#################################################################
# Install Dash from PPA                                         #
#################################################################
sudo add-apt-repository -y ppa:dash.org/dash
sudo apt-get update
sudo apt-get install -y dash

fi

################################################################
# Configure to auto start at boot					    #
################################################################
#file=$HOMEDIR/.dash 
#if [ ! -e "$file" ]
#then
#	mkdir $HOMEDIR/.dash
#fi
#printf '%s\n%s\n%s\n%s\n' 'daemon=1' 'server=1' 'rpcuser=u' 'rpcpassword=p' | tee $HOMEDIR/.dash/dash.conf
#file=/etc/init.d/dash
#if [ ! -e "$file" ]
#then
#	printf '%s\n%s\n' '#!/bin/sh' 'sudo dashd' | sudo tee /etc/init.d/dash
#	sudo chmod +x /etc/init.d/dash
#	sudo update-rc.d dash defaults	
#fi
#
#/usr/bin/dashd
echo "Dash has been setup successfully and is running..."
exit 0
