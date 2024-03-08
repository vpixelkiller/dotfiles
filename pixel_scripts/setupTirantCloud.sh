#!/bin/bash

tmux attach-session -d -t TirantCloudSession || tmux new-session -d -s TirantCloudSession
source ~/.dotfiles/pixel_scripts/check_dependencies.sh
is_docker_running

sessionCounter=0

tmux new-window -t TirantCloudSession:"$sessionCounter" -n 'Cloud-service'
tmux send-keys -t TirantCloudSession:"$sessionCounter" 'z cloud-service' C-m
if [ "$1" = "exec" ]; then
    tmux send-keys -t TirantCloudSession:"$sessionCounter" 'make logs' C-m
fi

((sessionCounter++)) 

tmux new-window -t TirantCloudSession:"$sessionCounter" -n 'Cloud-js'
tmux send-keys -t TirantCloudSession:"$sessionCounter" 'z cloud-js' C-m
if [ "$1" = "exec" ]; then
    tmux send-keys -t TirantCloudSession:"$sessionCounter" 'make up' C-m
fi

tmux attach-session -t TirantCloudSession


