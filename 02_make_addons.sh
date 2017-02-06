#!/bin/bash

cd "`dirname \"$0\"`"


log() {
  echo "$0 - $@"
}

error() {
  log "$@"
  exit 1
}

create_example() {
  file="live-addon-maker/$1"
  shift
  log "Executing $command"
  log "      for $file"
  if ! [ -f "$file" ]; then
    (
      cd "live-addon-maker"
      "$@"
    )
  fi
  [ -f "$file" ] || \
    error "File $file not found for command $@"
  files="$file $files"
}

files=""


[ -d "live-addon-maker" ] || \
  error "Can not find live-addon-maker directory. Run 01_setup.sh first!"


create_example examples/z-idle-python3.5.squashfs \
               examples/idle-python3.5.sh
create_example examples/z-sources.list.squashfs \
               examples/sources.list.sh
create_example examples/z-arduino-1.8.1-linux64.squashfs \
               examples/arduino-1.8.1-linux64.sh
create_example examples/z-flash.squashfs \
               examples/flash.sh
create_example z-app-inventor-starter.squashfs \
               examples/CoderDojoOS-special.sh software/app-inventor-starter
create_example z-PyCharm.squashfs \
               examples/CoderDojoOS-special.sh software/PyCharm z-PyCharm.squashfs
create_example z-Scratch2Installer.squashfs \
               examples/CoderDojoOS-special.sh software/Scratch2Installer
#  examples/CoderDojoOS-special.sh software/hamstermodell

sudo live-addon-maker/merge-addons.sh z-coderdojo.squashfs $files





