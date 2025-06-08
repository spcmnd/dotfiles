#!/bin/bash

SESSION_NAME="$1"

if [ -z "$SESSION_NAME" ]; then
	echo "Usage: $0 <session-name>"
	exit 1
fi

# Check if session already exists

tmux has-session -t "$SESSION_NAME" 2>/dev/null

if [ $? -eq 0 ]; then
  echo "Session $SESSION_NAME already exists. Attaching..."
  tmux attach-session -t "$SESSION_NAME"
  exit 0
fi

# Create new session

tmux new-session -d -s "$SESSION_NAME" -n main

case "$SESSION_NAME" in
  "AM-the-viewer-portal")
    tmux send-keys -t "$SESSION_NAME:1" "cd ~/dev/AM-the-viewer" Enter

    tmux new-window -d -t "$SESSION_NAME:2" -n server
    tmux send-keys -t "$SESSION_NAME:2" "cd ~/dev/AM-the-viewer" Enter
    tmux send-keys -t "$SESSION_NAME:2" "source .venv/bin/activate" Enter
    tmux send-keys -t "$SESSION_NAME:2" "python manage.py runserver 0.0.0.0:8000" Enter

    tmux new-window -d -t "$SESSION_NAME:3" -n portal
    tmux send-keys -t "$SESSION_NAME:3" "cd ~/dev/AM-the-viewer/typescript/portal" Enter
    tmux send-keys -t "$SESSION_NAME:3" "npm run dev" Enter

    tmux new-window -d -t "$SESSION_NAME:4" -n neovim
    tmux send-keys -t "$SESSION_NAME:4" "cd ~/dev/AM-the-viewer" Enter
    tmux send-keys -t "$SESSION_NAME:4" "nvim ." Enter

    tmux send-keys -t "$SESSION_NAME:1" 'flatpak run com.google.Chrome "http://127.0.0.1:8000/login" &' Enter
    tmux send-keys -t "$SESSION_NAME:1" 'clear' Enter
    ;;
  *)
    echo "Unknown project: $SESSION_NAME"
    tmux kill-session -t "$SESSION_NAME"
    exit 1
    ;;
esac

# Attach to the session

tmux select-window -t "$SESSION_NAME:0"
tmux attach-session -t "$SESSION_NAME"
