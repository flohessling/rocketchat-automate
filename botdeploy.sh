#!/bin/bash

# shell script to deploy hubot to rocket.chat installation in ubuntu/trusty64 vagrant box
# depending on install.sh install script for system configuration
# depending on rcdeploy.sh rocket.chat deployment script



npm -install -g yo generator-hubot

mkdir botfx
cd botfx
yo hubot



#	HOST=http://localhost
#	MONGO_URL=mongodb://localhost:27017/rocketchat
#	MONGO_OPLOG_URL=mongodb://localhost:27017/local
#	ROOT_URL=$HOST
#	PORT=3000
#	cd /var/www/
#	wget https://github.com/RocketChat/Rocket.Chat/archive/master.tar.gz
#	tar -xvzf master.tar.gz
#	mv Rocket.Chat-master rocket.chat

#	cd ./rocket.chat
#	meteor build --server "$HOST" --directory .

#	cd ./bundle/programs/server
#	npm install

#	cd ../..

#	rm -f pm2-rocket-chat.json
#	echo '{'                                                     > pm2-rocket-chat.json
#	echo '  "apps": [{'                                         >> pm2-rocket-chat.json
#	echo '    "name": "rocket.chat",'                           >> pm2-rocket-chat.json
#	echo '    "script": "/var/www/rocket.chat/bundle/main.js",' >> pm2-rocket-chat.json
#	echo '    "out_file": "/var/log/rocket.chat/app.log",'      >> pm2-rocket-chat.json
#	echo '    "error_file": "/var/log/rocket.chat/err.log",'    >> pm2-rocket-chat.json
#	echo "    \"port\": \"$PORT\","                             >> pm2-rocket-chat.json
#	echo '    "env": {'                                         >> pm2-rocket-chat.json
#	echo "      \"MONGO_URL\": \"$MONGO_URL\","                 >> pm2-rocket-chat.json
#	echo "      \"MONGO_OPLOG_URL\": \"$MONGO_OPLOG_URL\","     >> pm2-rocket-chat.json
#	echo "      \"ROOT_URL\": \"$ROOT_URL:$PORT\","             >> pm2-rocket-chat.json
#	echo "      \"PORT\": \"$PORT\""                            >> pm2-rocket-chat.json
#	echo '    }'                                                >> pm2-rocket-chat.json
#	echo '  }]'                                                 >> pm2-rocket-chat.json
#	echo '}'                                                    >> pm2-rocket-chat.json

#	pm2 start pm2-rocket-chat.json
#	pm2 save

