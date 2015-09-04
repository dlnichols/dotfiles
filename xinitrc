#!/bin/sh

/usr/bin/xrdb -merge /home/dan/.Xresources

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
xset -dpms s off s noblank
ibus-daemon -drx
unagi &

exec awesome
