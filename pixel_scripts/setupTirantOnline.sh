#!/bin/bash

tmux attach-session -d -t tOnlineSession || tmux new-session -d -s tOnlineSession
source ~/.dotfiles/pixel_scripts/check_dependencies.sh
is_docker_running

tmux new-window -t tOnlineSession:0 -n 'tolDependencies'
tmux send-keys -t tOnlineSession:0 'z dependencies' C-m
if [ "$1" = "exec" ]; then
    tmux send-keys -t tOnlineSession:0 'make up && make logs' C-m
fi

tmux new-window -t tOnlineSession:1 -n 'apiTol'
tmux send-keys -t tOnlineSession:1 'z apitol' C-m
tmux send-keys -t tOnlineSession:1 'wait_until_condition mongoTol' C-m &
wait $!
if [ "$1" = "exec" ]; then
    tmux send-keys -t tOnlineSession:1 'make serve' C-m
fi

tmux new-window -t tOnlineSession:2 -n 'tolUserApi'
tmux send-keys -t tOnlineSession:2 'z toluserapi/api' C-m
tmux send-keys -t tOnlineSession:2 'wait_until_condition mongoTol' C-m &
wait $!
if [ "$1" = "exec" ]; then
    tmux send-keys -t tOnlineSession:2 'make serve' C-m
fi

tmux new-window -t tOnlineSession:3 -n 'tolWeb'
tmux send-keys -t tOnlineSession:3 'z tolweb' C-m
tmux send-keys -t tOnlineSession:3 'wait_until_condition apitol' C-m &
tmux send-keys -t tOnlineSession:3 'wait_until_condition toluserapi' C-m &
wait $!
if [ "$1" = "exec" ]; then
    tmux send-keys -t tOnlineSession:3 'make serve' C-m
fi

tmux new-window -t tOnlineSession:4 -n 'tirantOnline'
tmux send-keys -t tOnlineSession:4 'z tirantonline/tol' C-m
if [ "$1" = "exec" ]; then
    tmux send-keys -t tOnlineSession:4 'ga' C-m
fi

tmux attach-session -t tOnlineSession

