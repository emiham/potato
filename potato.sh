#!/usr/bin/env sh

# shellcheck disable=SC2059

WORK=25
BREAK=5
LONG_BREAK=25
SESSIONS=4
INTERACTIVE=true
MUTE=false
AUDIO_FILE=/usr/lib/potato/notification.wav
NOTIFY=false

show_help() {
  cat <<-END
  usage: potato [-s] [-m] [-a /path/to/audio.wav] [-w m] [-b m] [-h]
      -s: simple output. Intended for use in scripts
          When enabled, potato outputs one line for each minute, and doesn't print the bell character
          (ascii 007)

      -m: mute -- don't play sounds when work/break is over
      -a /path/to/audio.wav: audio file to play when a period is over
      -n: send a notification when a period is over
      -w m: let work periods last m minutes (default is 25)
      -b m: let break periods last m minutes (default is 5)
      -B m: let long break periods last m minutes (default is 25)
      -r s: do s work sessions before a long break (default is 4)
      -h: print this message
END
}

play_notification() {
  aplay -q "$AUDIO_FILE" &
}

while getopts :sw:b:B:r:a:mnh? opt; do
  case "$opt" in
    s)
      INTERACTIVE=false
      ;;
    m)
      MUTE=true
      ;;
    n)
      NOTIFY=true
      ;;
    a)
      AUDIO_FILE=$OPTARG
      ;;
    w)
      WORK=$OPTARG
      ;;
    b)
      BREAK=$OPTARG
      ;;
    B)
      LONG_BREAK=$OPTARG
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
  CURR_SESSION=$((CURR_SESSION + 1))
  i=$WORK
  while [ "$i" -gt 0 ]; do
    printf "$time_left" "$i" "work"
    sleep 1m
    i=$((i - 1))
  done

  ! $MUTE && play_notification
  if $INTERACTIVE; then
    perl -MPOSIX -e 'tcflush(0, TCIFLUSH)'
    printf "\a"
    printf "\nWork over"
    $NOTIFY && notify-send potato "Work over"
    read -r _
  fi

  if [ "$((CURR_SESSION % SESSIONS))" -eq 0 ]; then
    j=$LONG_BREAK
    while [ "$j" -gt 0 ]; do
      printf "$time_left" "$j" "long break"
      sleep 1m
      j=$((j - 1))
    done
  else
    j=$BREAK
    while [ "$j" -gt 0 ]; do
      printf "$time_left" "$j" "break"
      sleep 1m
      j=$((j - 1))
    done
  fi

  ! $MUTE && play_notification
  if $INTERACTIVE; then
    perl -MPOSIX -e 'tcflush(0, TCIFLUSH)'
    printf "\a"
    printf "\nBreak over"
    $NOTIFY && notify-send potato "Break over"
    read -r _
  fi
done
