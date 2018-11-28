#!/bin/sh

#mise en place des valeurs par defaut
aptupdate="o"
aptupgrade="o"
installvsftpd="o"
anonymous='o'
local='o'
umask='o'
logs='o'

while [ -z $repok ] || [ $repok != 'ok' ]
	do
		read -p "Voulez-vous mettre a jour la liste des packages ? (o/n): " reponse
		aptupdate="$reponse"
		if [ "r"$reponse = "ro" ] || [ "r"$reponse = "rn" ];then
			repok="ok" 
		fi
	done

    repok="nok"
    while [ -z $repok ] || [ $repok != 'ok' ]
    do
        read -p "Voulez-vous mettre a jour les packages existants ? (o/n): " reponse
        aptupgrade="$reponse"
        if [ "r"$reponse = "ro" ] || [ "r"$reponse = "rn" ];then
            repok="ok"
        fi 
    done

    repok="nok"
    while [ -z $repok ] || [ $repok != 'ok' ]
    do
        read -p "Voulez-vous installer le serveur FTP avec vsftpd ? (o/n): " reponse
        installvsftpd="$reponse"
        if [ "r"$reponse = "ro" ] || [ "r"$reponse = "rn" ];then
            repok="ok"
        fi
    done
	
    repok="nok"
    while [ -z $repok ] || [ $repok != 'ok' ]
    do
        read -p "Voulez-vous que le serveur fonctionne en mode standalone ? (o/n): " reponse
        standalone="$reponse"
        if [ "r"$reponse = "ro" ] || [ "r"$reponse = "rn" ];then
            repok="ok"
        fi
    done
	
	repok="nok"
    while [ -z $repok ] || [ $repok != 'ok' ]
    do
        read -p "Voulez-vous permettre le telechargement de fichier en annonyme ? (o/n): " reponse
        anonymous="$reponse"
        if [ "r"$reponse = "ro" ] || [ "r"$reponse = "rn" ];then
            repok="ok"
        fi
    done
	
		repok="nok"
    while [ -z $repok ] || [ $repok != 'ok' ]
    do
        read -p "Retirer l'autorisation aux utilisateurs locaux de se connecter ? (o/n): " reponse
        local="$reponse"
        if [ "r"$reponse = "ro" ] || [ "r"$reponse = "rn" ];then
            repok="ok"
        fi
    done
	
		repok="nok"
    while [ -z $repok ] || [ $repok != 'ok' ]
    do
        read -p "Voulez-vous fixer le masque local a 022 (les fichiers remontés auront des droits en 755) ? (o/n): " reponse
        umask="$reponse"
        if [ "r"$reponse = "ro" ] || [ "r"$reponse = "rn" ];then
            repok="ok"
        fi
    done
	
		repok="nok"
    while [ -z $repok ] || [ $repok != 'ok' ]
    do
        read -p "Retirer l'enregistrement des logs pour les actions des utilisateurs ? (o/n): " reponse
        logs="$reponse"
        if [ "r"$reponse = "ro" ] || [ "r"$reponse = "rn" ];then
            repok="ok"
        fi
    done
	
	    repok="nok"
    while [ -z $repok ] || [ $repok != 'ok' ]
    do
        read -p "Créer un nouvel utilisateur ? (o/n): " reponse
        usercreate="$reponse"
        if [ "r"$reponse = "ro" ] || [ "r"$reponse = "rn" ];then
            repok="ok"
        fi
    done
	
	
resuminstall="\n\n------------------------------------------\n ------- Resume de l'installation -------\n------------------------------------------\n"
# Mettre a jour la liste des packages
if [ $aptupdate = "o" ];then
    installok="no"
    apt-get -y update && installok="yes" && resuminstall=$resuminstall"La liste des packages est finalisee.\n\n"
	if [ $installok = "no" ];then
		resuminstall=$resuminstall"!!!La liste des packages n'a pas ete finalisee. (apt-get -y update)!!!\n\n"
	fi
else
	resuminstall=$resuminstall"---La liste des packages n'est pas demandee.---\n\n"
fi
echo -e $resuminstall



# Mettre a jour les packages existants
if [ $aptupgrade = "o" ];then
    installok="no"
    apt-get -y upgrade && installok="yes" && resuminstall=$resuminstall"La mise a jour des packages existants est finalisee.\n\n"
	if [ $installok = "no" ];then
		resuminstall=$resuminstall"!!!La mise a jour des packages existants n'a pas ete finalisee. (apt-get -y upgrade)!!!\n\n"
	fi
else
	resuminstall=$resuminstall"---La mise a jour des packages existants n'est pas demandee.---\n\n"
fi
echo -e $resuminstall

# Installer le démon vsftpd
if [ $installvsftpd = "o" ];then
    installok="no"
    apt-get install vsftpd -y && installok="yes" && resuminstall=$resuminstall"L'installation de vsftpd est finalisee.\n\n"
	if [ $installok = "no" ];then
		resuminstall=$resuminstall"!!!L'installation de vsftpd n'a pas ete finalisee. (apt-get install iptables -y)!!!\n\n"
	fi
else
	resuminstall=$resuminstall"---L'installation de vsftpd n'est pas demandee.---\n\n"
fi
echo -e $resuminstall

if [ $standalone = "o" ];then
    installok="no"
    for fichier in /etc/vsftpd.conf
    do
    sed -i -e "s/listen=NO/listen=YES/g" "$fichier"
	installok=yes
    done
		if [ $installok="yes" ];then
	resuminstall=$resuminstall"L'activation du mode standalone a été finalisee.\n\n"

	fi
	if [ $installok = "no" ];then
		resuminstall=$resuminstall"!!!L'activation du mode standalone n'a pas ete finalisee. ()!!!\n\n"
	fi
else
	resuminstall=$resuminstall"---L'activation du mode standalone n'est pas demandee.---\n\n"
fi
echo -e $resuminstall

if [ $anonymous = "o" ];then
    installok="no"
    for fichier in /etc/vsftpd.conf
    do
    sed -i -e "s/anonymous_enable=NO/anonymous_enable=YES/g" "$fichier"
	installok=yes
    done
		if [ $installok="yes" ];then
	resuminstall=$resuminstall"L'activation du téléchargement annonyme a été finalisee.\n\n"

	fi
	if [ $installok = "no" ];then
		resuminstall=$resuminstall"!!!L'activation du téléchargement annonyme n'a pas ete finalisee. ()!!!\n\n"
	fi
else
	resuminstall=$resuminstall"---L'activation du téléchargement annonyme n'est pas demandee.---\n\n"
fi
echo -e $resuminstall

if [ $local = "o" ];then
    installok="no"
    for fichier in /etc/vsftpd.conf
    do
    sed -i -e "s/local_enable=YES/local_enable=NO/g" "$fichier"
	installok=yes
    done
		if [ $installok="yes" ];then
	resuminstall=$resuminstall"Retirer l'autorisation de la connexion des utilisateurs locaux a été finalisee.\n\n"

	fi
	if [ $installok = "no" ];then
		resuminstall=$resuminstall"!!!Retirer l'autorisation de la connexion les utilisateurs locaux n'a pas ete finalisee. ()!!!\n\n"
	fi
else
	resuminstall=$resuminstall"---Retirer l'autorisation de la connexion les utilisateurs locaux n'est pas demandee.---\n\n"
fi
echo -e $resuminstall

if [ $umask = "o" ];then
    installok="no"
    for fichier in /etc/vsftpd.conf
    do
    sed -i -e "s/#local_umask=022/local_umask=022/g" "$fichier"
	installok=yes
    done
		if [ $installok="yes" ];then
	resuminstall=$resuminstall"Fixer le masque local a 022 a été finalisee.\n\n"

	fi
	if [ $installok = "no" ];then
		resuminstall=$resuminstall"!!!Fixer le masque local a 022 a été finalisee n'a pas ete finalisee. ()!!!\n\n"
	fi
else
	resuminstall=$resuminstall"---Fixer le masque local a 022 a été finalisee n'est pas demandee.---\n\n"
fi
echo -e $resuminstall

if [ $logs = "o" ];then
    installok="no"
    for fichier in /etc/vsftpd.conf
    do
    sed -i -e "s/xferlog_enable=YES/xferlog_enable=NO/g" "$fichier"
	installok=yes
    done
		if [ $installok="yes" ];then
	resuminstall=$resuminstall"L'enregistrement des logs pour les actions des utilisateurs a été retiré.\n\n"

	fi
	if [ $installok = "no" ];then
		resuminstall=$resuminstall"!!!l'enregistrement des logs pour les actions des utilisateurs n'a pas été retiré. ()!!!\n\n"
	fi
else
	resuminstall=$resuminstall"---Retirer l'enregistrement des logs pour les actions des utilisateurs n'a pas été retiré.---\n\n"
fi
echo -e $resuminstall

if [ $usercreate = "o" ];then
    installok="no"
	read -p "Sur quel site faut-il créer l'espace ftp dans /var/www ? " site
	read -p "Quel sera le nom du nouvel utilisateur ? " siteusername
    useradd -m -d /var/www/$site/ $siteusername 
	passwd $siteusername  && installok="yes"
		if [ $installok="yes" ];then
	resuminstall=$resuminstall"La création de l'utilisateur est finalisee.\n\n"
	fi
	if [ $installok = "no" ];then
		resuminstall=$resuminstall"!!!l'enregistrement des logs pour les actions des utilisateurs n'a pas été retiré. ()!!!\n\n"
	fi
else
	resuminstall=$resuminstall"---Retirer l'enregistrement des logs pour les actions des utilisateurs n'a pas été retiré.---\n\n"
fi
echo -e $resuminstall

