#!/bin/sh
# toggle touchpad on and off on hp pavilion dm4

# use 'xinput list' and 'xinput list-props' to find
# the correct local value for $PAD

PAD='SynPS/2 Synaptics TouchPad'

A=`xinput list-props "$PAD" | sed -n -e 's/.*Device Enabled ([0-9][0-9]*):\t\(.*\)/\1/p' `

# echo "A =" $A
if [ $A -eq 1 ]; then
	xinput set-int-prop "$PAD" "Device Enabled" 8 0
else
	xinput set-int-prop "$PAD" "Device Enabled" 8 1
fi
