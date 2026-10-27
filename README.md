# finix config

## provisioning

1. install finix as normal
2. setup password:
   1. `mkdir /mnt/etc/finix-passwords`
   2. `chmod 700 /mnt/etc/finix-passwords`
   3. `mkpasswd -m yescrypt > /mnt/etc/finix-passwords/<youruser>`
   4. `chmod 600 /mnt/etc/finix-passwords/<youruser>`
3. clone config, adjust accounts, host, and hardware
probably idk
