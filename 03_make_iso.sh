#!/bin/bash

cd "`dirname \"$0\"`"

iso_name="`ls live-addon-maker/*.iso | grep -v coderdojo`"
new_iso="`basename \"$iso_name\" | sed s/desktop/coderdojo/`"
if [ "$new_iso" == "$iso_name" ]; then
  new_iso="${iso_name%.*}-coderdojo.iso"
fi

sudo live-addon-maker/add-addons-to-iso.sh "$iso_name" "$new_iso" \
                                           z-coderdojo.squashfs
