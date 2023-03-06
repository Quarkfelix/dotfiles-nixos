#!/usr/bin/env bash


# move dotfiles folder to .config
echo "copying dotfiles to /home/marc/.config/dotfiles-nixos ..."
mv ../dotfiles-nixos /home/marc/.config
cd /home/marc/.config/dotfiles-nixos
echo "done"

# make all scripts executable and owned by me
for f in $(find $HOME"/.config/dotfiles-nixos" -name '*.sh'); do
	chmod +x "$f"
	chown marc "$f"
done
#extra for hack theme
cd $HOME"/.config/dotfiles-nixos/themes/hack/polybar/scripts"
chown marc check-network checkupdates
chmod +x check-network checkupdates

# make files for themes executable
cd $HOME"/.config/dotfiles-nixos/themes"
for d in */ ; do
	cd $d
	chmod +x apply.sh
	cd ..
done

# create symlink for alacritty config
ln -s /home/marc/.config/dotfiles-nixos/alacritty/ /home/marc/.config/alacritty



## setup ssh keys

files=( $HOME"/.ssh/id_ed25519" $HOME"/.ssh/id_ed25519.pub" )

generate_keys () {
	echo "--generating new keys ..."
	echo "--deleting old keys (if there are remains)"
	
	for i in "${files[@]}"
	do
		rm $i
	done
	echo "--done"
	echo "--generating new keypair"
	ssh-keygen -t ed25519 -C "marc-felix.schmitz@protonmail.com"
	echo "--done"
}

# loop through ssh files. if one in missing generate new ones
for i in "${files[@]}"
do
	echo $i
	if test -f $i; then
		echo "-key exists"
	else
		# files missing.
		echo "-key missing"
		generate_keys
		break
	fi
done

echo "-writing into output file for later"
	pub_key=$(<$HOME"/.ssh/id_ed25519.pub")
	echo "" >> $HOME/.config/dotfiles-nixos/manual_config
	echo "GitHub Setup:" >> $HOME/.config/dotfiles-nixos/manual_config
	echo "link: https://github.com/settings/keys" >> $HOME/.config/dotfiles-nixos/manual_config
	echo "public key: "$pub_key >> manual$HOME/.config/dotfiles-nixos/manual_config_config
	echo "" >> $HOME/.config/dotfiles-nixos/manual_config
echo "-done"

## end setup ssh keys

## set git email and name
#git config --global user.email "you@example.com"
#git config --global user.name "Your Name"
