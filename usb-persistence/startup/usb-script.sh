#!/bin/bash

folder="$1"
script="$folder/startup.sh"
log="$folder/startup.log"

echo "Looking for script $script"
if ! [ -f "$script" ]; then
  echo "No script $script found"
  echo "Creating such a script"
  (
    echo "#!/bin/bash"
    echo "#"
    echo "# I am a startup script."
    echo "# My output goes to $log"
    echo "# I am started when the system boots."
    echo "echo 'You should see this text in $log'"
  ) > "$script"
  chmod 777 "$script"
  chmod +x "$script"
fi

echo "Executing $script"
"$script" 1>>"$log" 2>>"$log"
