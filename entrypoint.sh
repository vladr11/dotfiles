#!/bin/sh

DOCKER_SOCKET=/var/run/docker.sock
DOCKER_GROUP=docker
USER=vladrusu

if [ ! -z "$GIT_USER_NAME" ] && [ ! -z "$GIT_USER_EMAIL" ]; then
    git config --global user.name "$GIT_USER_NAME"
    git config --global user.email "$GIT_USER_EMAIL"
fi

chmod 777 /var/run/docker.sock

chown -R $USER: $HOME/.config
chown -R $USER: $HOME/.kube
chown -R $USER: $HOME/.ssh
chown -R $USER: $HOME/zsh
chown -R $USER: $HOME/.tmux
chown -R $USER: $HOME/.stack /home/vladrusu/.stack-work
exec /sbin/su-exec $USER /bin/zsh "$@"

