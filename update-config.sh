#!/bin/bash

currentDirectory=$PWD
homeDirectory=$HOME

pull_latest_version () {
	echo
	echo "[*] Pulling latest repository version..."
	git pull > /dev/null
	echo "[*] Done."
}

update_tmux_conf () {
	tmuxLoggingPluginPath="$HOME/Documents/tmux-logging"

	echo
	echo "[*] Updating tmux configuration..."
	cp -f $currentDirectory/.tmux.conf $homeDirectory/.tmux.conf
	echo "[*] Tmux configuration updated!"

	if [ ! -d "$tmuxLoggingPluginPath" ]; then
		echo "[*] Tmux logging pluggin is not present."

		while true; do
			read -p "[*] Do you want to import it? [Y/N] " yn

			case $yn in
				[Yy]* )
					echo "[*] Cloning tmux-logging..."
					git clone https://github.com/tmux-plugins/tmux-logging.git $tmuxLoggingPluginPath > /dev/null 2>&1
					echo "[*] Done."
					break
					;;
				[Nn]* )
					break
					;;
				* )
					break
					;;
			esac
		done
	fi

	echo "[*] Loading updated Tmux configuration..."
	tmux source-file "$HOME/.tmux.conf" > /dev/null 2>&1
	echo "[*] Configuration loaded!"
}

main () {
	echo "---"
	echo "Config Updater - V1.0 - By spcmnd"
	echo "---"
	while true; do
		read -p "Do you want to update Tmux configuration? [Y/N] " yn

		case $yn in
			[Yy]* ) 
				pull_latest_version
				update_tmux_conf
				break
				;;
			[Nn]* ) 
				break
				;;
			* ) 
				echo "Please answer Y or N."
				;;
		esac
	done
}

main
