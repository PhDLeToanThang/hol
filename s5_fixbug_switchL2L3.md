1. Supported Cisco IOU/IOL Images for Eveng
Basically, pod support all the Cisco IOU/IOL images but below are recommended one.

Type	EVE Image Name	Version	vRAM
L2	L2-ADVENTERPRISEK9-M-15.1-20130726.bin	I86BI_LINUXL2-ADVENTERPRISEK9-M 15.1(20130726:213425)	192
L3	L3-ADVENTERPRISEK9_IVS-M-15.3-0.9T.bin	I86BI_LINUX-ADVENTERPRISEK9_IVS-M 15.3(0.9)T	128
2. Download Cisco IOU/IOL Images for pod
Images provided below are strictly for educational purposes and are not hosted on the networkhunt.com server. We are just indexing the links found on the internet for educational purposes only.

You can download Cisco IOU/IOL images from the below links.
1. Download Cisco IOU/IOL Images.

3. Add Cisco IOU/IOL images to pod
IOL or IOS On Linux also called IOU or IOS On Unix. IOL is a simulator available for Cisco internal use only. IOL refers to the Linux version, compiled for i386 architecture. IOU refers to the Unix (Solaris) version compiled for Sparc architecture. The term IOU usually refers to IOL too.

Because IOL is an internal IOS version, IOL can be used by Cisco employees or by authorized customers only.

Upload the downloaded image to the EVE using for example FileZilla or WinSCP to:  /opt/unetlab/addons/iol/bin

Type the following command to fix permissions:

/opt/unetlab/wrappers/unl_wrapper -a fixpermissions
3. License for Cisco IOU/IOL images: CiscoIOUKeygen.py
#! /usr/bin/python
print("*********************************************************************")
print("Cisco IOU License Generator - Kal 2011, python port of 2006 C version")
print("Modified to work with python3 by c_d 2014")
import os
import socket
import hashlib
import struct

# get the host id and host name to calculate the hostkey
hostid=os.popen("hostid").read().strip()
hostname = socket.gethostname()
ioukey=int(hostid,16)
for x in hostname:
 ioukey = ioukey + ord(x)
print("hostid=" + hostid +", hostname="+ hostname + ", ioukey=" + hex(ioukey)[2:])

# create the license using md5sum
iouPad1 = b'\x4B\x58\x21\x81\x56\x7B\x0D\xF3\x21\x43\x9B\x7E\xAC\x1D\xE6\x8A'
iouPad2 = b'\x80' + 39*b'\0'
md5input=iouPad1 + iouPad2 + struct.pack('!i', ioukey) + iouPad1
iouLicense=hashlib.md5(md5input).hexdigest()[:16]

print("\nAdd the following text to ~/.iourc:")
print("[license]\n" + hostname + " = " + iouLicense + ";\n")
print("You can disable the phone home feature with something like:")
print(" echo '127.0.0.127 xml.cisco.com' >> /etc/hosts\n")

Copy the above text and create a text file and save as with the name CiscoIOUKeygen.py
After creating the license python script, upload it to the pod directory
–/opt/unetlab/addons/iol/bin/
After uploading the script go to the directory by using the below command-
cd /opt/unetlab/addons/iol/bin/
Check the directory content by below command-
ls -l
you will be able to see a file with the name – CiscoIOUKeygen.py
Now run the python script by using the below command-
python CiscoIOUKeygen.py
it will give you some like the below output
root@pod:/opt/unetlab/addons/iol/bin# python CiscoIOUKeygen.py
Cisco IOU License Generator - Kal 2011, python port of 2006 C version
Modified to work with python3 by c_d 2014
hostid=007f0101, hostname=pod, ioukey=7f0343 Add the following text to /opt/unetlab/addons/iol/bin/iourc
[license]

pod = 972f30267ef51616;

Now, we will create licenses for IOU/IOL images

nano /opt/unetlab/addons/iol/bin/iourc

paste the license and press ctrl+x to save

[license]
pod = 972f30267ef51616;

We have successfully added the Cisco IOU/IOL images to pod with the license.

![image](https://github.com/PhDLeToanThang/handonlabs/assets/106635733/2ae81a1f-7f4a-425e-ab3b-9b754c473d47)

5. Testing Cisco IOU/IOL images in pod
