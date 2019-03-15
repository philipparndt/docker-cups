#! /bin/sh
sudo apt-get install -y cups printer-driver-gutenprint
yes | cp ./config/cups.conf /etc/cups/cups.conf
yes | cp ./config/printers.conf /etc/cups/printers.conf 
sudo service cups restart