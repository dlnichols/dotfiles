#!/usr/bin/env bash

DOTFILE_ROOT="$HOME/.dotfiles"

#Files to link symbolically
LINK_FILES[1]=.gitconfig
LINK_FILES[2]=.vimrc
LINK_FILES[3]=.zshrc
LINK_FILES[4]=.zprofile
LINK_FILES[5]=.npmrc
LINK_FILES[6]=.vim/setup.sh
LINK_FILES[7]=.vim/update.sh
LINK_FILES[8]=.vim/h_media.session
LINK_FILES[9]=.xprofile
LINK_FILES[10]=.Xresources
LINK_FILES[11]=.config/awesome/rc.lua
LINK_FILES[12]=.config/awesome/theme.lua
LINK_FILES[13]=bin/gmusic
LINK_FILES[14]=bin/cadult
LINK_FILES[15]=bin/cdefault
LINK_FILES[16]=bin/cprivate
LINK_FILES[17]=bin/h_media
LINK_FILES[18]=bin/gkeep

#Files to make executable
EXEC_FILES[1]=.xprofile
EXEC_FILES[2]=bin/gmusic
EXEC_FILES[3]=bin/cdefault
EXEC_FILES[4]=bin/cadult
EXEC_FILES[5]=bin/cprivate
EXEC_FILES[6]=bin/h_media
EXEC_FILES[7]=bin/gkeep

remove_file () {
  echo "Removing $1"
  [ -e "$1" ] && rm "$1"
}

link_file () {
  echo "Linking $1 to $2"
  [ -e "$2" ] && ln -s "$2" "$1"
}

exec_file () {
  echo "Setting executable bit on $1"
  [ -e "$1" ] && chmod +x "$1"
}

# For link_files...
echo "Linking dotfiles..."
for file in "${LINK_FILES[@]}"; do
  homefile="$HOME/$file"
  case "$file" in
    .*)
      linkfile="$DOTFILE_ROOT/${file:1}"
      ;;
    *)
      linkfile="$DOTFILE_ROOT/${file:0}"
      ;;
  esac

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

echo "Setting executable bits..."
for file in "${EXEC_FILES[@]}"; do
  exec_file "$HOME/$file"
done
