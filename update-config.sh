#!/bin/bash

currentDirectory=$PWD
homeDirectory=$HOME

pull_latest_version () {
	echo
	echo '[*] Pulling latest repository version...'
	git pull > /dev/null
	echo '[*] Done.'
}

update_tmux_conf () {
	echo
	echo '[*] Updating tmux configuration...'
	cp -f $currentDirectory/.tmux.conf $homeDirectory/.tmux.conf
	echo '[*] Tmux configuration updated!'
}

main () {
	echo '---'
	echo 'Config Updater - V1.0 - By spcmnd'
	echo '---'
	while true; do
		read -p "Do you want to update Tmux configuration? [Y/N] " yn

		case $yn in
			[Yy]* ) pull_latest_version; update_tmux_conf; break;;
			[Nn]* ) break;;
			* ) echo 'Please answer Y or N.';;
		esac
	done
}

main
