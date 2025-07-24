chmod +x ./debuginit-object-storage
./debuginit-object-storage

chmod +x ./debuginit-object-storage-x86_64-unknown-linux-musl

chmod +x list_ports.sh
chmod +x deploy_debuginit.sh
ss -tuln
ss -tuln | awk 'NR>1 {split($5, a, ":"); print a[length(a)]}' | sort -n | uniq
ufw allow 21000

lsof -i -P -n | grep LISTEN