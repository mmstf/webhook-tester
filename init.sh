#!/bin/bash

###
# Running docker image
###
docker pull mmstf/webhook-tester:v1.0.0
docker run -itd mmstf/webhook-tester:v1.0.0 --rm --name webhook-tester-util -p 15777:15777

###
# Configuring nginx
###
os_type=$(cat /etc/os-release)
debian=$(grep -i debian /etc/os-release)
fedora=$(grep -i fedora /etc/os-release)
is_nginx_installed=$(nginx -v 2>&1 | grep -i version)

# check linux distro family
if [[ -n "$debian" ]]; then
    if [[ ! "$is_nginx_installed" ]]; then
        echo "[DEBIAN] Installing nginx with apt..."
        apt-get update -y
        apt-get upgrade -y
        apt-get install nginx -y
    fi
elif [[ -n "$fedora" ]]; then
    if [[ -n $is_nginx_installed ]]; then
        echo "[FEDORA] Installing nginx with yum..."
        yum update -y
        yum install nginx -y
    fi
fi

read -p "Enter your domain (e.g., webhook.xxx.uz): " SERVER_NAME

if [[ -z "$SERVER_NAME" ]]; then
    echo "Server name is empty! Needed to be configured manually!!!"
else

    if [[ -n "$debian" ]]; then
        NGINX_CONFIG="/etc/nginx/sites-available/$SERVER_NAME.conf"
    elif [[ -n "$fedora" ]]; then
        NGINX_CONFIG="/etc/nginx/conf.d/$SERVER_NAME.conf"
    fi

cat <<EOF | sudo tee $NGINX_CONFIG > /dev/null
    server {
        server_name $SERVER_NAME;

        location / {
            proxy_pass http://127.0.0.1:15777;
            
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        }
    }
EOF

    if [[ -n "$debian" ]]; then ln -s $NGINX_CONFIG /etc/nginx/sites-enabled/"$SERVER_NAME".conf; fi

    echo "Nginx configuration for $SERVER_NAME has been created at $NGINX_CONFIG"
fi



# FIX your domain name and restart nginx

nginx -t
nginx -s reload
