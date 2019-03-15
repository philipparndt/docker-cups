#! /bin/sh
sudo apt-get install -y cups printer-driver-gutenprint
yes | sudo cp ./config/cupsd.conf /etc/cups/cupsd.conf
yes | sudo cp ./config/printers.conf /etc/cups/printers.conf 
sudo service cups restart