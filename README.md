# finix config

## provisioning

1. install finix as normal
2. setup secrets key:
   1. `mkdir -p /mnt/var/lib/secrets`
   2. `chmod 700 /mnt/var/lib/secrets`
   3. `age-keygen -o /mnt/var/lib/secrets/key.txt`
   4. `chmod 600 /mnt/var/lib/secrets/key.txt`
3. clone config, adjust accounts, host, and hardware
probably idk

## secrets

secrets are age encrypted files in `secrets/`, decrypted on activation to `/run/secrets` with the key from provisioning

1. `age-keygen -y /var/lib/secrets/key.txt` prints the public key
2. `mkpasswd -m yescrypt | age -r <publickey> -o secrets/ilari-password.age`
3. `age -r <publickey> -o secrets/wifi-eduroam.age` and `secrets/wifi-aalto.age`, type the password and press ctrl+d
4. `git add secrets`, flakes can't see untracked files
