#!/bin/sh
# Copyright (c) 2014 John Ko

install_pkg (){
	pkg-static info $1 > /dev/null 2> /dev/null || pkg-static install -y $1 || exit 1
}

for i in git py27-pip py27-fabric ; do
	install_pkg $i
done

ln -shf python2.7 /usr/local/bin/python || exit 1

if [ ! -e $HOME/littlechef/fix ]; then
	git clone https://github.com/johnko-chef/littlechef-freebsd.git $HOME/littlechef || exit 1
fi
mkdir $HOME/new_kitchen
cd $HOME/new_kitchen
$HOME/littlechef/fix new_kitchen || exit 1

cat > $HOME/new_kitchen/littlechef.cfg <<EOF
[userinfo]
user = root
keypair-file = ~/.ssh/id_rsa
encrypted_data_bag_secret = 
[kitchen]
node_work_path = /tmp/chef-solo/
EOF

# littlechef/fabric/paramiko can't use ecdsa keys
if [ ! -e ~/.ssh/id_rsa ]; then
	ssh-keygen -N '' -t rsa -b 4096 -f ~/.ssh/id_rsa
fi

echo 'You may want to:'
echo '# set path = ($HOME/littlechef $path)'
echo '# cd $HOME/new_kitchen'
echo '# echo {} > nodes/10.123.234.35.json'
echo '# fix node:10.123.234.35 ssh:"uptime"'
