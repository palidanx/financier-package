# Recommend running this script as a user other than root.
# adduser financier
# usermod -aG sudo financier

# Set up swap file
sudo dd if=/dev/zero of=/swapfile bs=1M count=1024
sudo mkswap /swapfile
sudo swapon /swapfile


# Install couchdb
echo "deb https://apache.bintray.com/couchdb-deb xenial main" | sudo tee -a /etc/apt/sources.list
curl -L https://couchdb.apache.org/repo/bintray-pubkey.asc | sudo apt-key add -
sudo apt-get update && sudo apt-get install -y couchdb

# Install node
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs

# Git
sudo apt-get install -y git

# Get source code
git clone https://github.com/palidanx/financier-package.git fin


# Setup couchdb
cd fin
npm install
node ./install/setup_couchdb.js

# Build
npm config set jobs 1 
npm run build

# Start Me
#update Repos list
sudo apt-get update
#install nginx
sudo apt-get install nginx

#Activate Firewall
sudo ufw enable

#Show apps
sudo ufw app list
#Allow nginx http
sudo ufw allow 'Nginx Full'
#show status of firewall
sudo ufw status


#Add Certbot for Lets Encrypt To be installed
sudo add-apt-repository ppa:certbot/certbot
#INstall Added Packages
sudo apt-get update
#Install Certbot for nginx
sudo apt-get install python-certbot-nginx
echo "*****************************************************************************************"
echo "Add A domain name to certbot"
echo "Find the existing server_name line and replace the underscore, _, with your domain name:"
echo "Ex: server_name example.com www.example.com;"
echo "save the file ^X"
echo "Y for yes then keep dafualt file name (aka press enter)"
echo "*****************************************************************************************"
echo "Press Enter to continue Install of Certbot configuration"
read certbotenter
# add domain name to certbot
# Find the existing server_name line and replace the underscore, _, with your domain name:
# Ex: server_name example.com www.example.com;
# save the file ^X
# Y for yes then keep dafualt file name (aka press enter)
sudo nano /etc/nginx/sites-available/default
# Test to make sure the file is good
sudo nginx -t
# Reload nginx configuration
sudo systemctl reload nginx

#set nginx to allow for https
sudo ufw allow 'Nginx Full'
# Remove previous rule
sudo ufw delete allow 'Nginx HTTP'
# Get status for posterity
sudo ufw status
echo "Type the domain name you have linked with your droplet"
read domain1


# Get SSL cert
sudo certbot --nginx -d $domain1 
# choose option 2
# test certbot for auto renwal
sudo certbot renew --dry-run

#Setup nginx as a revese proxy
#edit location block  to this use the port that the app is runnign on
#location / {
#        proxy_pass http://localhost:8080;
#        proxy_http_version 1.1;
#        proxy_set_header Upgrade $http_upgrade;
#        proxy_set_header Connection 'upgrade';
#        proxy_set_header Host $host;
#        proxy_cache_bypass $http_upgrade;
#    }
#location /db {
#        rewrite /db/(.*) /$1 break;
#        proxy_pass http://127.0.0.1:5984/;
#        proxy_redirect off;
#        proxy_buffering off;
#        proxy_set_header Host $host;
#    }
echo "*****************************************************************************************"
echo "edit location block  to this use the port that the app is runnign on"
echo "#location / {"
echo "       proxy_pass http://localhost:8080;"
echo "       proxy_http_version 1.1;"
echo "       proxy_set_header Upgrade $\http_upgrade;"
echo "       proxy_set_header Connection 'upgrade';"
echo "       proxy_set_header Host $\host; "
echo "       proxy_cache_bypass $\http_upgrade; "
echo "   }"
echo "location /db { "
echo "        rewrite /db/(.*) /$\1 break;"
echo "        proxy_pass http://127.0.0.1:5984/;"
echo "        proxy_redirect off;"
echo "        proxy_buffering off;"
echo "        proxy_set_header Host $\host;"
echo "    }"
echo "*****************************************************************************************"
echo "Press Enter to continue Configuration of NGINX reverse Proxy"
read nginxenter
sudo nano /etc/nginx/sites-available/default
# Test Sysntax
sudo nginx -t
# Restart nginx
sudo systemctl restart nginx

#End Me

# Daemonize
sudo npm install pm2 -g
sudo pm2 startup
sudo pm2 start ./api/index.js

ip=$(ip -f inet -o addr show eth0|cut -d\  -f 7 | cut -d/ -f 1)

echo ""
echo ""
echo "#################################################################"
echo ""
echo "If there were not any errors above, you can go to the following"
echo "url in your browser to load financier!"
echo ""
echo "https://$ip:8080"
echo ""
echo "#################################################################"
