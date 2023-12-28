# handonlabs
Hand on labs include documents, topology, guide to self practices for cloud computing science environment laboratory 

# Bài luận về đề tài Hand On Labs:
search: "Hand on labs include documents, topology, guide to self practices for students such as cloud computing, IoT gateway, edge cloud and Fog computing, stem science environment laboratory"
[https://dev.azure.com/ThangLeRobusta/Hand%20On%20Labs%20for%20Training%20Labs%20Center]

và

Phác thảo 2: Bài viết luận bàn về prototype mô hình và các dẫn ý chi tiết hoá lời giới thiệu
[https://dev.azure.com/ThangLeRobusta/Hand%20On%20Labs%20for%20Training%20Labs%20Center/_wiki/wikis/Private-Cloud-with-HeathCare-Apps-and-Training-Labs-Center.wiki/13/?wikiVersion=GBwikiMaster&_a=edit&pagePath=/Ph%C3%A1c%20th%E1%BA%A3o%202%3A%20B%C3%A0i%20vi%E1%BA%BFt%20lu%E1%BA%ADn%20b%C3%A0n%20v%E1%BB%81%20prototype%20m%C3%B4%20h%C3%ACnh%20v%C3%A0%20c%C3%A1c%20d%E1%BA%ABn%20%C3%BD%20chi%20ti%E1%BA%BFt%20ho%C3%A1%20l%E1%BB%9Di%20gi%E1%BB%9Bi%20thi%E1%BB%87u]



# Phần 3. Cách dùng các hàm iShare2 để tìm và download Labs templates VMS:
.TH ISHARE2 1 "July 2023" "Version 2.1.7" "User Commands"
.SH NAME
ishare2 \- Download and manage network device images
.SH SYNOPSIS
.B ishare2
[\fIaction\fR] [\fIparam1\fR] [\fIparam2\fR]
.SH DESCRIPTION
The \fBishare2\fR utility allows users to search for, download, and manage network device images for use in network simulations and labs.
.SH ACTIONS
.TP
\fBsearch\fR
Search for images by type or name.
.TP
\fBpull\fR
Download an image by type and number.
.TP
\fBinstalled\fR
Show installed images on the server.
.TP
\fBlabs\fR
Show labs on the server and download images for those labs.
.TP
\fBmylabs\fR
Same as \fBlabs\fR command but using a customized path to labs.
.TP
\fBrelicense\fR
Generate a new \fBiourc\fR license for bin images.
.TP
\fBupgrade\fR
Retrieve a menu that allows users to upgrade \fBishare2\fR and PNETLab VM.
.TP
\fBchangelog\fR
Show the latest changes made to \fBishare2\fR.
.TP
\fBgui\fR
Start or stop the \fBishare2\fR web app for use in a browser.
.TP
\fBhelp\fR
Show useful information and usage instructions.
.TP
\fBtest\fR
Test if \fBishare2\fR dependencies are reachable (GitHub, Google Spreadsheets).
.SH PARAMETERS
.TP
\fIparam1\fR
Specify the image type or name for certain actions.
.TP
\fIparam2\fR
Specify the image number, which can be obtained using \fBishare2 search\fR command for certain actions.
.SH EXAMPLES
.B ishare2 search
.B ishare2 search all
.B ishare2 search bin
.B ishare2 search qemu
.B ishare2 search dynamips

.B ishare2 search vios
.B ishare2 search win-
.B ishare2 search winserver
.B ishare2 search kali
.B ishare2 search mikro
.B ishare2 search forti
.B ishare2 search nxos
.B ishare2 search vmx
.B ishare2 search esxi
.B ishare2 search palo
.B ishare2 search Licensed

.B ishare2 pull bin <number>
.B ishare2 pull qemu <number>
.B ishare2 pull dynamips <number>

.B ishare2 pull bin all
.B ishare2 pull qemu all (Not available for qemu type due to its large size)
.B ishare2 pull dynamips all

.B ishare2 installed all
.B ishare2 installed bin
.B ishare2 installed qemu
.B ishare2 installed dynamips
.B ishare2 installed docker

.B ishare2 labs
.B ishare2 labs <number>

.B ishare2 mylabs <path>
.B ishare2 mylabs <path> <number>
.B ishare2 mylabs <path> all

.B ishare2 gui install
.B ishare2 gui start
.B ishare2 gui stop
.B ishare2 gui restart

.B ishare2 relicense
.B ishare2 upgrade
.B ishare2 changelog
.B ishare2 help
.B ishare2 test
.SH AUTHOR
Alex <alex@alex-dev.me>
.SH TELEGRAM
https://t.me/NetLabHub
