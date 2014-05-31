#!/usr/bin/env bash

# Run bash_it install...
DOTFILE_ROOT="$HOME/.dotfiles"
LINK_FILES=( bashrc bash_profile bash_logout gitconfig vimrc )

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
