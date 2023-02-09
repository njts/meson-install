#!/bin/bash
 
cpu_arch="$(uname -m)"
freespace="$(df --output=avail -h "$PWD" | sed '1d;s/[^0-9]//g')" # print free space
installdir="$(findmnt -n -T .)" # print installation partion / disk
AMD="https://staticassets.meson.network/public/meson_cdn/v3.1.19/meson_cdn-linux-amd64.tar.gz"
ARM="https://staticassets.meson.network/public/meson_cdn/v3.1.19/meson_cdn-linux-arm64.tar.gz"

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

# configuration

    read -p "
    Welcome!

    Before you start, you need to register at https://dashboard.meson.network/register to get your token.

    Press ENTER to continue:"
        read -p  "    
        Please enter your token: " token
        read -p  "      
        Define a port [default is 443. press ENTER for defaut]: " port
        port="${port:-443}" #default value if imput is empty
        read -p  "    
        Cache size [minimum requried: 20GB, available: ${freespace}GB, Default: 30GB. press ENTER for default]:" storage
        storage="${storage:-30}" #default value if imput is empty
        read -p "
    
                Your token: $token
                Selected port: $port
                Cache: ${storage}GB of ${freespace}GB free space in ${installdir}

        Please ENTER to verify:"
        echo "        $(now) Installation started!"

                

# x86_64 installation
# detect x86_64 CPUs
if [ "${cpu_arch}" = "x86_64" ]; then
echo "$(now) Downloding Meson for x86-64"
wget $AMD
echo "$(now) Downloaded!"
 tar -zxf meson_cdn-linux-amd64.tar.gz
  echo "$(now) Extracted!"
  rm -f meson_cdn-linux-amd64.tar.gz
   cd meson_cdn-linux-amd64
    sudo ufw allow $port
    sudo systemctl restart ufw
    echo "$(now) Firewall updated"
    echo "$(now) Port $port opened"
    sudo ./service install meson_cdn
    sudo ./meson_cdn config set --token=$token --https_port=$port  --cache.size=$storage
    sudo ./service start meson_cdn


# arm64 installation
# detect arm64 CPUs
elif [[ "${cpu_arch}" = "arm64" ]] || [[ "${cpu_arch}" = "aarch64" ]]; then
 echo "$(now) Downloding Meson for arm64"
  wget $ARM
  echo "$(now) Downloaded!"
  tar -zxf meson_cdn-linux-arm64.tar.gz
   echo "$(now) Extracted!"
   rm -f meson_cdn-linux-arm64.tar.gz
    cd ./meson_cdn-linux-arm64
     sudo ufw allow $port
     sudo systemctl restart ufw
     echo "$(now) Firewall updated"
     echo "$(now) Port $port opened"
     sudo ./service install meson_cdn
     sudo ./meson_cdn config set --token=$token --https_port=$port  --cache.size=$storage
     sudo ./service start meson_cdn
    
# Other CPU types error message
   else
    echo "$(now) Unfortunately Meson Network does not support  ${cpu_arch} type CPUs yet" 

      fi
