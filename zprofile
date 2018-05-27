typeset -U path
path=($HOME/.rvm/bin ./scripts $HOME/bin $HOME/Android/Sdk/platform-tools /usr/local/heroku/bin $path[@])
export EDITOR="nvim"
export NVM_DIR="$HOME/.nvm"
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_NDK="/opt/android-ndk/r15c"
unset SSH_AGENT_PID
export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

#alias kdec='signer -o decrypt -r ~/.ssh/kramer/kfw.pri.pem
function kdec() {
  echo ${1%.kfw}
  if [[ ! ${1} =~ ".kfw"$ ]]; then
    echo "Must select a KFW for decryption."
    return 1
  fi
  if [[ ! -f ${1} ]]; then
    echo "File ${1} does not exist."
  fi
  signer -o decrypt -r ~/.ssh/kramer/kfw.pri.pem -e ${1} -c ${1%.kfw}.tgz
}

function kenc() {
  echo ${1%.kfw}
  if [[ ! ${1} =~ ".tgz"$ ]]; then
    echo "Must select a TGZ for encryption."
    return 1
  fi
  if [[ ! -f ${1} ]]; then
    echo "File ${1} does not exist."
  fi
  signer -o encrypt -u ~/.ssh/kramer/kfw.pub.pem -c ${1} -e ${1%.tgz}.kfw
}
