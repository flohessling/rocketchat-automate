#!/bin/bash

# shell script to configure ubuntu/trusty64 vagrant box to run rocket.chat

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
apt-get update
apt-get install -y git nodejs npm mongodb-org curl

ln -s /usr/bin/nodejs /usr/bin/node

npm install nave -g
nave usemain 0.10.40

curl https://install.meteor.com/ | sh

npm install pm2 -g
pm2 startup

mkdir -p /var/www/
mkdir -p /var/log/rocket.chat

service mongod stop

echo " " > /etc/hosts
echo "127.0.0.1 localhost" >> /etc/hosts
echo "127.0.0.1 vagrant-ubuntu-trusty-64" >> /etc/hosts
echo " " >> /etc/hosts
echo "# The following lines are desirable for IPv6 capable hosts" >> /etc/hosts
echo "::1 ip6-localhost ip6-loopback" >> /etc/hosts
echo "fe00::0 ip6-localnet" >> /etc/hosts
echo "ff00::0 ip6-mcastprefix" >> /etc/hosts
echo "ff02::1 ip6-allnodes" >> /etc/hosts
echo "ff02::2 ip6-allrouters" >> /etc/hosts
echo "ff02::3 ip6-allhosts" >> /etc/hosts

echo "replication:" >> /etc/mongod.conf
echo "     replSetName: \"001-rs\"" >> /etc/mongod.conf

service mongod start

sleep 5

cfg="{
    _id: '001-rs',
    members: [
        {_id: 1, host: 'localhost:27017'}
    ]
}"

mongo localhost:27017 --eval "JSON.stringify(db.adminCommand({'replSetInitiate' : $cfg}))"

sleep 3

# rocket.chat deployment

HOST=http://localhost
MONGO_URL=mongodb://localhost:27017/rocketchat
MONGO_OPLOG_URL=mongodb://localhost:27017/local
ROOT_URL=$HOST
PORT=3000
cd /var/www/
wget https://github.com/RocketChat/Rocket.Chat/archive/master.tar.gz
tar -xvzf master.tar.gz
mv Rocket.Chat-master rocket.chat

cd ./rocket.chat
meteor build --server "$HOST" --directory .

cd ./bundle/programs/server
npm install

cd ../..

rm -f pm2-rocket-chat.json
echo '{'                                                     > pm2-rocket-chat.json
echo '  "apps": [{'                                         >> pm2-rocket-chat.json
echo '    "name": "rocket.chat",'                           >> pm2-rocket-chat.json
echo '    "script": "/var/www/rocket.chat/bundle/main.js",' >> pm2-rocket-chat.json
echo '    "out_file": "/var/log/rocket.chat/app.log",'      >> pm2-rocket-chat.json
echo '    "error_file": "/var/log/rocket.chat/err.log",'    >> pm2-rocket-chat.json
echo "    \"port\": \"$PORT\","                             >> pm2-rocket-chat.json
echo '    "env": {'                                         >> pm2-rocket-chat.json
echo "      \"MONGO_URL\": \"$MONGO_URL\","                 >> pm2-rocket-chat.json
echo "      \"MONGO_OPLOG_URL\": \"$MONGO_OPLOG_URL\","     >> pm2-rocket-chat.json
echo "      \"ROOT_URL\": \"$ROOT_URL:$PORT\","             >> pm2-rocket-chat.json
echo "      \"PORT\": \"$PORT\""                            >> pm2-rocket-chat.json
echo '    }'                                                >> pm2-rocket-chat.json
echo '  }]'                                                 >> pm2-rocket-chat.json
echo '}'                                                    >> pm2-rocket-chat.json

pm2 start pm2-rocket-chat.json
pm2 save

