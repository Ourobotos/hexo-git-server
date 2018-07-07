#!/bin/sh

# copy all keys to authorized_keys
if [ "$(ls -A /hexo-server/keys/)" ]; then
  cd /home/git
  for file in /hexo-server/keys/*.pub
  do
    cat $file >> .ssh/authorized_keys
  done
  chown -R git:git .ssh
  chmod 700 .ssh
  chmod -R 600 .ssh/*
fi

# if the empty repo doesn't exists, copy one
if [ ! -d "/hexo-server/repos/hexo.git" ]; then
  cp /home/git/hexo.git /hexo-server/repos/hexo.git -r
  chmod +x /hexo-server/repos/hexo.git/hooks/post-receive
fi

# give repos file read write and exec ability
if [ "$(ls -A /hexo-server/repos/)" ]; then
  cd /hexo-server/repos
  chown -R git:git .
  chmod -R ug+rwX .
  find . -type d -exec chmod g+s '{}' +
  cd /hexo-server/html
  chown -R git:git .
  chmod -R ug+rwX .
  find . -type d -exec chmod g+s '{}' +  
fi

/usr/sbin/sshd -D