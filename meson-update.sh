#!/bin/bash
 
cpu_arch="$(uname -m)"
freespace="$(df --output=avail -h "$PWD" | sed '1d;s/[^0-9]//g')" # print free space
installdir="$(findmnt -n -T .)" # print installation partion / disk
find_amd="$(find . -name meson_cdn-linux-amd64)"
find_arm="$(find . -name meson_cdn-linux-arm64)"
# functions
now() {
  date +"%Y/%m/%d %H:%M:%S"
} # display current time

printf '\n%.0s' {1,100}
echo "
     ░█▀▄▀█ ░█▀▀▀ ░█▀▀▀█ ░█▀▀▀█ ░█▄─░█ 　 ▀█▀ ░█▄─░█ ░█▀▀▀█ ▀▀█▀▀ ─█▀▀█ ░█─── ░█─── ░█▀▀▀ ░█▀▀█ 
     ░█░█░█ ░█▀▀▀ ─▀▀▀▄▄ ░█──░█ ░█░█░█ 　 ░█─ ░█░█░█ ─▀▀▀▄▄ ─░█── ░█▄▄█ ░█─── ░█─── ░█▀▀▀ ░█▄▄▀ 
     ░█──░█ ░█▄▄▄ ░█▄▄▄█ ░█▄▄▄█ ░█──▀█ 　 ▄█▄ ░█──▀█ ░█▄▄▄█ ─░█── ░█─░█ ░█▄▄█ ░█▄▄█ ░█▄▄▄ ░█─░█\
"
printf '\n%.0s' {1,100}

# x86_64 update
# detect x86_64 CPUs
if [ "${cpu_arch}" = "x86_64" ]; then
echo "$(now) Nice to see you again
       
       
       Your current configuration:


"
cd $find_amd

sudo ./meson_cdn config show
read -p "


    Press ENTER to change your configuration:"
    read -p  "    
        Please re-enter your token: " token
        read -p  "      
        Define a new port [default is 443. press ENTER for defaut]: " port
        port="${port:-443}" #default value if imput is empty
        read -p  "    
        Change the cache size [minimum requried: 20GB, available: ${freespace}GB, Default: 30GB. press ENTER for default]:" storage
        storage="${storage:-30}" #default value if imput is empty
        read -p "
    
                Your new token: $token
                New selected port: $port
                New cache: ${storage}GB of ${freespace}GB free space in ${installdir}

        Please ENTER to verify:"
        echo "        $(now) Reconfiguration started!"

    sudo ufw allow $port
    sudo systemctl restart ufw
    echo "$(now) Firewall updated"
    echo "$(now) Port $port opened"
    sudo ./meson_cdn config set --token=$token --https_port=$port  --cache.size=$storage
    sudo ./service restart meson_cdn
echo "

$(now) That's it! Updated"   

# arm64 update
# detect arm64 CPUs
elif [[ "${cpu_arch}" = "arm64" ]] || [[ "${cpu_arch}" = "aarch64" ]]; then
echo "$(now) Nice to see you again
       
       
       Your current configuration:


"
cd $find_arm

sudo ./meson_cdn config show
read -p "


    Press ENTER to change your configuration:"
    read -p  "    
        Please re-enter your token: " token
        read -p  "      
        Define a new port [default is 443. press ENTER for defaut]: " port
        port="${port:-443}" #default value if imput is empty
        read -p  "    
        Change the cache size [minimum requried: 20GB, available: ${freespace}GB, Default: 30GB. press ENTER for default]:" storage
        storage="${storage:-30}" #default value if imput is empty
        read -p "
    
                Your new token: $token
                New selected port: $port
                New cache: ${storage}GB of ${freespace}GB free space in ${installdir}

        Please ENTER to verify:"
        echo "        $(now) Reconfiguration started!"

    sudo ufw allow $port
    sudo systemctl restart ufw
    echo "$(now) Firewall updated"
    echo "$(now) Port $port opened"
    sudo ./meson_cdn config set --token=$token --https_port=$port  --cache.size=$storage
    sudo ./service restart meson_cdn
echo "

$(now) That's it! Updated"
    
      fi