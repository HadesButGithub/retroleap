#!/bin/sh

CONFIG=/configs/retroarch.cfg.leapstergs

valencia=$(fbset | grep 480x272)
if [[ $? == 0 ]]; then
    CONFIG=/configs/retroarch.cfg.leappad2
fi

rio=$(fbset | grep 1024x600)
if [[ $? == 0 ]]; then
    CONFIG=/configs/retroarch.cfg.leappadultra
fi

# If gmenunx is present, run it instead of retroarch.
# TODO: Fix this to be more graceful across different devices etc.
if test -f "/usr/share/gmenunx/gmenunx"
then
	while `true`
	do
          # Volume control slider for Didj
	  /usr/share/gmenunx/./gmenunx
	  echo "Restarting gmenunx...."
	done
else

	while `true`
	do
	  echo 0 > /sys/devices/platform/lf2000-fb.0/graphics/fb0/blank
	  export SDL_NOMOUSE=1
	  retroarch -v -c $CONFIG 2> /root/retro.log
	  echo "Restarting program..."
	done
fi
