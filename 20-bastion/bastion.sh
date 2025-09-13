#!/bin/bash

yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform

##Below commands are used for t3.micro
# growpart /dev/nvme0n1 4
# lvextend -L +20G /dev/RootVG/rootvol
# lvextend -L +20G /dev/RootVG/homevol

# xfs_growfs /
# xfs_growfs /home

###For instance type t2.micro below are the commands to extend the file sizes
sudo growpart /dev/xvda 4
sudo pvresize /dev/xvda4
lvextend -L 20G /dev/RootVG/rootVol
lvextend -L 20G /dev/RootVG/homeVol
xfs_growfs /
xfs_growfs /home
