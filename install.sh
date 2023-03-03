#!/usr/bin/env bash


# move dotfiles folder to .config
echo "copying dotfiles to /home/marc/.config/dotfiles-nixos ..."
mv ../dotfiles-nixos /home/marc/.config
cd /home/marc/.config/dotfiles-nixos
echo "done"

# make all scripts executable
echo "making scripts executable ..."
cd scripts
chmod +x `ls`
echo "done"

# add all scripts to path
echo "adding scripts folder to PATH"
export PATH="/home/marc/.config/dotfiles-nixos/scripts:${PATH}"
echo "done"



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
	echo "" >> manual_config
	echo "GitHub Setup:" >> manual_config
	echo "link: https://github.com/settings/keys" >> manual_config
	echo "public key: "$pub_key >> manual_config
	echo "" >> manual_config
echo "-done"

## end setup ssh keys

## set git email and name
#git config --global user.email "you@example.com"
#git config --global user.name "Your Name"
