#!/usr/bin/env sh

set -xe

wp core download --allow-root
wp config create --dbname=wordpress --dbuser=root --dbpass=pass --dbhost=database --allow-root
wp core install --url=localhost --title="WordPress WooCommerce" --admin_user=admin --admin_password=admin --admin_email=admin@example.com --allow-root
wp plugin install woocommerce --activate --allow-root

exec "$@"
