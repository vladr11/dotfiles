#!/bin/sh

DOCKER_SOCKET=/var/run/docker.sock
DOCKER_GROUP=docker
USER=vladrusu

if [ ! -z "$GIT_USER_NAME" ] && [ ! -z "$GIT_USER_EMAIL" ]; then
    git config --global user.name "$GIT_USER_NAME"
    git config --global user.email "$GIT_USER_EMAIL"
fi

chmod 777 /var/run/docker.sock

chown -R vladrusu: /home/vladrusu/.config
chown -R vladrusu: /home/vladrusu/.kube
chown -R vladrusu: /home/vladrusu/.ssh
chown -R vladrusu: /home/vladrusu/zsh
chown -R vladrusu: /home/vladrusu/.tmux
chown -R vladrusu: /home/vladrusu/.stack /home/vladrusu/.stack-work
exec /sbin/su-exec vladrusu /bin/zsh "$@"

