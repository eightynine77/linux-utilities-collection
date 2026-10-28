#!/bin/bash

# you can also run this script from a .desktop file by using this command for the Exec:
# gnome-terminal -- /bin/bash -c "path_to_the_shutdown-now.sh_script"

while true; do
    echo shutdown menu
    echo ""
    echo ""
    echo "[a] shutdown"
    echo "[s] restart"
    echo "[d] cancel"
    echo -n "> "
    IFS= read -n1 choice
    echo

    case "$choice" in
        a|A|' ') 
echo shutting down system...
systemctl poweroff
break 
;;  
        s|S) 
echo restarting system...
systemctl reboot
break 
;; 
        d|D) break ;;     
        *) 
echo "invalid choice"
continue 
;;    
    esac
done

#this script shuts down your system
#NOTE: you must use a linux distro that supports systemctl or have systemctl installed