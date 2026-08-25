#!/bin/bash

# you can also run this script from a .desktop file by using this command for the Exec:
# gnome-terminal -- /bin/bash -c "path_to_the_shutdown-now.sh_script"

while true; do
    echo do you want to shutdown this system?
    echo ""
    echo ""
    echo "[a] yes"
    echo "[s] no"
    echo -n "> "
    read -n1 choice
    echo

    case "$choice" in
        a|A) 
echo shutting down system...
systemctl poweroff
break 
;;  
        s|S) break ;;     
        *) 
echo "invalid choice"
continue 
;;    
    esac
done

#this script shuts down your system
#NOTE: you must use a linux distro that supports systemctl or have systemctl installed
