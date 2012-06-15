#!/bin/bash -e

# Virtual Host Config:

# feel free to change, update, improve, and release this script

# suggestions of feedback? reach me at junior.holowka@gmail.com

# latest update 14/Jun/2012

#################################################################################
# path="/home/user/Workspace/" > your workspace or htdocs                       #
# host="localhost.project"     > /etc/hosts - (Ex: 127.0.0.1 localhost.project) #
# dir="project"                > /home/user/Workspace/project                   #
# paramn="/app/webroot"        > some framework root                            #
#################################################################################

# check for root
if [ "$(id -u)" != "0" ]; then
   echo "You must run this script as root" 1>&2
   exit 1
fi

path="$1"
host="$2"
dir="$3"
paramn="$4"


echo -e "\033[1m> Criando referencia $host no arquivo /etc/hosts ...\033[0m\n"
	sudo sh -c 'echo "127.0.0.1          '${host}'" >> /etc/hosts'
echo ""

echo -e "\033[1m> Criando $host em /etc/apache2/sites-available ...\033[0m\n"
	sudo touch /etc/apache2/sites-available/$host

cat > /etc/apache2/sites-available/$host<<EOF
<VirtualHost *:80>
	ServerName $host
	ServerSignature Off
	DocumentRoot $path$dir$paramn
	ErrorLog     $path$dir/logging/apache-error_log
	CustomLog    $path$dir/logging/apache-access_log common

	<Directory "$path$dir">
		<IfModule mod_rewrite.c>
			RewriteEngine On
			RewriteBase /
			RewriteRule ^index\.php- [L]
			RewriteCond %{REQUEST_FILENAME} !-f
			RewriteCond %{REQUEST_FILENAME} !-d
			RewriteRule . /index.php [L]
		</IfModule>
	</Directory>
</VirtualHost>
EOF

echo ""

echo -e "\033[1m> Habilitando o dominio em /etc/apache2/sites-enabled ...\033[0m\n"
	sudo a2ensite $host
echo ""

echo -e "\033[1m> Habilitando módulo rewrite no apache2 ...\033[0m\n"
	sudo a2enmod rewrite
echo ""

echo -e "\033[1m> Reload no Apache ...\033[0m\n"
	sudo /etc/init.d/apache2 reload
echo ""
 
echo -e "\033[1m> Criando link simbólico para $path  ...\033[0m\n"
	cd /var/www/
	sudo ln -s $path$dir $dir
echo ""

echo -e "\033[1m> Reiniciando o Apache ...\033[0m\n"
	sudo /etc/init.d/apache2 restart
echo ""

echo -e "\033[1m> Virtual Host criado com sucesso! ...\033[0m\n"

