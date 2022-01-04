#!/bin/bash

WORK=25
PAUSE=5
LONG_PAUSE=25
SESSIONS=4
INTERACTIVE=true
MUTE=false

show_help() {
	cat <<-END
		usage: potato [-s] [-m] [-w m] [-b m] [-h]
		    -s: simple output. Intended for use in scripts
		        When enabled, potato outputs one line for each minute, and doesn't print the bell character
		        (ascii 007)

		    -m: mute -- don't play sounds when work/break is over
		    -w m: let work periods last m minutes (default is 25)
		    -b m: let break periods last m minutes (default is 5)
		    -B m: let long break periods last m minutes (default is 25)
				-r m: number of work sessions before long break (default is 4)
		    -h: print this message
	END
}

play_notification() {
	aplay -q /usr/lib/potato/notification.wav&
}

while getopts :sw:b:B:r:m opt; do
	case "$opt" in
	s)
		INTERACTIVE=false
	;;
	m)
		MUTE=true
	;;
	w)
		WORK=$OPTARG
	;;
	b)
		PAUSE=$OPTARG
	;;
	B)
		LONG_PAUSE=$OPTARG
	;;
	r)
		SESSIONS=$OPTARG
	;;
	h|\?)
		show_help
		exit 1
	;;
	esac
done

time_left="%im left of %s "

if $INTERACTIVE; then
	time_left="\r$time_left"
else
	time_left="$time_left\n"
fi

CURR_SESSION=0
while true
do
	((CURR_SESSION++))
	for ((i=$WORK; i>0; i--))
	do
		printf "$time_left" $i "work"
		sleep 1m
	done

	! $MUTE && play_notification
	if $INTERACTIVE; then
		read -d '' -t 0.001
		echo -e "\a"
		echo "Work over"
		read
	fi

	if (($CURR_SESSION % $SESSIONS == 0))
	then
		for ((i=$LONG_PAUSE; i>0; i--))
		do
			printf "$time_left" $i "long pause"
			sleep 1m
		done
	else
		for ((i=$PAUSE; i>0; i--))
		do
			printf "$time_left" $i "pause"
			sleep 1m
		done
	fi

	! $MUTE && play_notification
	if $INTERACTIVE; then
		read -d '' -t 0.001
		echo -e "\a"
		echo "Pause over"
		read
	fi
done
