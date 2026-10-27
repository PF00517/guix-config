herd start cow-store /mnt
export GUILE_LOAD_PATH=/root/init:$GUILE_LOAD_PATH
guix system -L /root/init init /root/init/guix/system/guix.scm /mnt
