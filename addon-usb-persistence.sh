#!/bin/bash

cd "`dirname \"$0\"`"

sudo live-addon-maker/make-addon.sh ./link.iso z-usb-persistence.squashfs \
                                    -a usb-persistence/ /opt/usb-persistence/ \
                                    -s 'usb-persistence' \
                                       '/opt/usb-persistence/startup.sh'
