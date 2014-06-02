#!/usr/bin/env bash

# Run bash_it install...
DOTFILE_ROOT="$HOME/.dotfiles"
LINK_FILES[1]=bashrc
LINK_FILES[2]=bash_profile
LINK_FILES[3]=bash_logout
LINK_FILES[4]=gitconfig
LINK_FILES[5]=vimrc
LINK_FILES[6]=zshrc
LINK_FILES[7]=vim/setup.sh
LINK_FILES[8]=vim/update.sh
LINK_FILES[9]=vim/h_media.session
LINK_FILES[10]=xinitrc
LINK_FILES[11]=Xresources
LINK_FILES[11]=xprofile

remove_file () {
  echo "Removing $1"
  [ -e "$1" ] && rm "$1"
}

link_file () {
  echo "Linking $1 to $2"
  [ -e "$2" ] && ln -s "$2" "$1"
}

# For link_files...
for file in "${LINK_FILES[@]}"; do
  homefile="$HOME/.$file"
  linkfile="$DOTFILE_ROOT/$file"

  # Check if the file exists
  if [ -e "$homefile" ]; then
    echo "$homefile exists"

    # File exists, check if it is a symbolic link
    if [ ! -h "$homefile" ]; then
      echo "$homefile is not symbolic"

      # File is not a symbolic link, remove it and link to the dotfile
      remove_file "$homefile"
      link_file "$homefile" "$linkfile"
    fi
  else
    # File does not exist, link it
    link_file "$homefile" "$linkfile"
  fi
done

chmod +x xinitrc
