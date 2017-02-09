#!/bin/bash

sleep 4


rm -f /home/ubuntu/Desktop/examples.desktop \
      /home/ubuntu/Desktop/ubiquity.desktop

sudo -H -u ubuntu gsettings set com.canonical.Unity.Launcher favorites "['application://ubiquity.desktop', 'application://org.gnome.Nautilus.desktop', 'application://firefox.desktop', 'application://coderdojopotsdam.desktop', 'application://org.gnome.Software.desktop', 'application://unity-control-center.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices']"


