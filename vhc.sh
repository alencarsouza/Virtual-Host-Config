#!/bin/bash -e

# Virtual Host Config:

# feel free to change, update, improve, and release this script

# suggestions of feedback? reach me at junior.holowka@gmail.com

# latest update 17/February/2012

#################################################################################
# path="/home/user/Workspace/" > your workspace or htdocs                       #
# host="localhost.project"     > /etc/hosts - (Ex: 127.0.0.1 localhost.project) #
# dir="project"                > /home/user/Workspace/project                   #
# paramn="/app/webroot"        > some framework paramn                          #
#################################################################################

path="$1"
host="$2"
dir="$3"
paramn="$4"


echo -e "\033[1m> Criando referencia $host no arquivo /etc/hosts ...\033[0m\n"
	sudo sh -c 'echo "127.0.0.1          '${host}'" >> /etc/hosts'
echo ""

echo -e "\033[1m> Criando $host em /etc/apache2/sites-available ...\033[0m\n"
	sudo touch /etc/apache2/sites-available/$host

	sudo sh -c 'echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/'${host}''
	sudo sh -c 'echo "ServerName '${host}'" >> /etc/apache2/sites-available/'${host}''
	sudo sh -c 'echo "ServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/'${host}''
	sudo sh -c 'echo "ServerSignature Off" >> /etc/apache2/sites-available/'${host}''
	sudo sh -c 'echo "LogLevel warn" >> /etc/apache2/sites-available/'${host}''
	sudo sh -c 'echo "CustomLog /var/log/apache2/'${host}'-access.log combined" >> /etc/apache2/sites-available/'${host}''
	sudo sh -c 'echo "ErrorLog /var/log/apache2/'${host}'-error.log" >> /etc/apache2/sites-available/'${host}''
	
	sudo sh -c 'echo "DocumentRoot '${path}''${dir}''${paramn}'" >> /etc/apache2/sites-available/'${host}''
	sudo sh -c 'echo "<Directory '${path}''${dir}'>" >> /etc/apache2/sites-available/'${host}''
	sudo sh -c 'echo "Options Indexes FollowSymLinks MultiViews" >> /etc/apache2/sites-available/'${host}''
	sudo sh -c 'echo "AllowOverride All" >> /etc/apache2/sites-available/'${host}''
	sudo sh -c 'echo "Order allow,deny" >> /etc/apache2/sites-available/'${host}''
	sudo sh -c 'echo "allow from all" >> /etc/apache2/sites-available/'${host}''
	sudo sh -c 'echo "</Directory>" >> /etc/apache2/sites-available/'${host}''

	sudo sh -c 'echo "</VirtualHost>" >> /etc/apache2/sites-available/'${host}''

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




