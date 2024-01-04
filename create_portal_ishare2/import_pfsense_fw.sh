#!/bin/bash ######Update 2 By Maosen 20170419######
qemu=$(pwd)
icon="/opt/unetlab/html/images/icons"
include="/opt/unetlab/html/includes"
template="/opt/unetlab/html/templates" 
	cp -rf $qemu/pfsense.php $template/pfsense.php
	rm -rf $qemu/pfsense.php
	echo -e "\033[31mGreat!!!\033[0m \"pfSense Device\" import successfully!!!"
	rm -rf $qemu/pfsense.sh
