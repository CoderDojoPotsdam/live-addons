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
  add_file "$file" "$@"
}

files=""


[ -d "live-addon-maker" ] || \
  error "Can not find live-addon-maker directory. Run 01_setup.sh first!"

add_file() {
  local file="$1"
  shift
  [ -f "$file" ] || \
    error "File $file not found for command $@"
  files="$file $files"
}

addon() {
  script="$1"
  name="${script:6}"
  name="${name%.sh}"
  addon="z-$name.squashfs"
  if [ -e "$addon" ]; then
    echo "Addon $addon exists"
  else
    log "Executing $script"
    log "      for $file"
    "$script"
  fi
  add_file "$addon" "$script"
}

create_example examples/z-idle-python3.5.squashfs \
               examples/idle-python3.5.sh
create_example examples/z-sources.list.squashfs \
               examples/sources.list.sh
create_example examples/z-arduino-1.8.1-linux64.squashfs \
               examples/arduino-1.8.1-linux64.sh
create_example examples/z-flash.squashfs \
               examples/flash.sh
#create_example z-app-inventor-starter.squashfs \
#               examples/CoderDojoOS-special.sh software/app-inventor-starter
create_example z-PyCharm.squashfs \
               examples/CoderDojoOS-special.sh software/PyCharm z-PyCharm.squashfs
create_example z-Scratch2Installer.squashfs \
               examples/CoderDojoOS-special.sh software/Scratch2Installer
#  examples/CoderDojoOS-special.sh software/hamstermodell

for script in addon-*.sh; do
  addon "$script"
done

# Final step: squash the addons
sudo live-addon-maker/merge-addons.sh z-coderdojo.squashfs $files





