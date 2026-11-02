cd /mnt
mkdir -p boot home root gnu/store gnu/persist var/log var/lib var/guix snapshots

for vol in home root boot gnu gnu/store gnu/persist var var/log var/lib var/guix snapshots; do
    btrfs subvolume create @$vol
    mount --bind @$vol $vol
done

cd @gnu/persist
mkdir -p etc/guix etc/ssh etc/wireguard
