#!/bin/bash -
PATH=/bin:/usr/bin:/sbin:/usr/sbin

if [[ -z "$1" ]] 
then
  echo "Usage: $0 domain.com"
  exit
fi

if [[ -z "$SUDO_USER" ]]
  then
  echo "Use sudo"
  exit
fi

CHOICES="Overwrite Skip"

# The domain being created
DOMAIN=$1
ESCAPED_DOMAIN=${DOMAIN/\./\\\\.}

# This directory holds the templates for the apache and logrotate conf files
DEFAULT_TEMPLATE_DIR="$(dirname $0)/templates"
USER_TEMPLATE_DIR="/home/$SUDO_USER/a2mksite_templates"

# This is where we'll create the conf files
APACHE_CONF_DIR="/etc/apache2/sites-available"
LOGROTATE_CONF_DIR="/etc/logrotate.d"
LOGROTATE_SITES_DIR="$LOGROTATE_CONF_DIR/sites.d"

# These are the conf files
APACHE_CONF="$APACHE_CONF_DIR/$DOMAIN"
LOGROTATE_CONF="$LOGROTATE_SITES_DIR/$DOMAIN.conf"

# This is where the site itself will be created
SITES_DIR="/home/$SUDO_USER/vhosts"
SITE_DIR="$SITES_DIR/$DOMAIN"
PUBLIC_DIR="$SITE_DIR/public"
LOG_DIR="$SITE_DIR/log"

echo "Disabling Site..."
/usr/sbin/a2dissite $DOMAIN
echo "Deleting files..."
REGEX_DOMAIN="$(echo "$DOMAIN" | sed 's/[^-A-Za-z0-9_]/\\&/g')"
sed -i.bak "/127.0.0.1 $REGEX_DOMAIN/d" /etc/hosts
rm -f $LOGROTATE_CONF
rm -f $APACHE_CONF
rm -rf $SITE_DIR

echo "Restarting Apache..."
/usr/sbin/apache2ctl graceful

echo "ALL DONE!"
