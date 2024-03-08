#!/bin/bash

tmux attach-session -d -t sofiaSession || tmux new-session -d -s sofiaSession
source ~/.dotfiles/pixel_scripts/check_dependencies.sh
is_docker_running

sessionCounter=0

if ! mongoTol; then
    tmux new-window -t sofiaSession:"$sessionCounter" -n 'tolDependencies'
    tmux send-keys -t sofiaSession:"$sessionCounter" 'z dependencies' C-m
    tmux send-keys -t sofiaSession:"$sessionCounter" 'make up && make logs' C-m

    ((sessionCounter++)) 
fi

tmux new-window -t sofiaSession:"$sessionCounter" -n 'apitolSidekiq'
tmux send-keys -t sofiaSession:"$sessionCounter" 'z apitol' C-m
if [ "$1" = "exec" ]; then
    tmux send-keys -t sofiaSession:"$sessionCounter" 'make sidekiq' C-m
fi

((sessionCounter++)) 

tmux new-window -t sofiaSession:"$sessionCounter" -n 'SofiaService'
tmux send-keys -t sofiaSession:"$sessionCounter" 'z sofia-service' C-m
if [ "$1" = "exec" ]; then
    tmux send-keys -t sofiaSession:"$sessionCounter" 'make logs' C-m
fi

((sessionCounter++)) 

tmux new-window -t sofiaSession:"$sessionCounter" -n 'SofiaJS'
tmux send-keys -t sofiaSession:"$sessionCounter" 'z sofia-js' C-m
if [ "$1" = "exec" ]; then
    tmux send-keys -t sofiaSession:"$sessionCounter" 'make up' C-m
fi


tmux attach-session -t sofiaSession


