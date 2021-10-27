#!/bin/bash

currentDirectory=$PWD
homeDirectory=$HOME

ask_pull_latest_version () {
	while true; do
		read -p "Do you want to pull the latest version of files? [Y/N] " yn

		case $yn in
			[Yy]* )
				pull_latest_version
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

pull_latest_version () {
	echo
	echo "[*] Pulling latest repository version..."
	git pull > /dev/null
	echo "[*] Done."
	echo
}

ask_update_tmux_conf () {
	while true; do
		read -p "Do you want to update Tmux configuration? [Y/N] " yn

		case $yn in
			[Yy]* )
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
	echo "[*] Done."
	echo
}

ask_update_bashrc () {
	while true; do
		read -p "Do you want to update your bashrc? [Y/N] " yn

		case $yn in
			[Yy]* )
				update_bashrc
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

update_bashrc () {
	bashrcPath=$homeDirectory/.bashrc

	if grep -Fxq "# spcmnd's custom config" $bashrcPath
	then
    echo
		echo "[*] Config is already loaded!"
	else
		echo
		echo "[*] Adding custom config to .bashrc..."
		echo "" >> $bashrcPath
		echo "# spcmnd's custom config" >> $bashrcPath
		echo "export SPCMNDCONFIGPATH=\"$homeDirectory/Documents/dotfiles\"" >> $bashrcPath
		echo "source \"\$SPCMNDCONFIGPATH/.bashrc\"" >> $bashrcPath
		echo "" >> $bashrcPath
	fi

	echo "[*] Done."
	echo
}

main () {
	echo "---"
	echo "Config Updater - V0.2 - By spcmnd"
	echo "---"
	echo
	ask_pull_latest_version
	ask_update_tmux_conf

	if ! grep -Fxq "# spcmnd's custom config" $homeDirectory/.bashrc
	then
		ask_update_bashrc
	fi
}

main
