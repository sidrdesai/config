#!/bin/bash

stylus=`/usr/bin/xsetwacom --list | grep stylus | grep -Go '[0-9][0-9]'`

xsetwacom --set $stylus MapToOutput HDMI1
