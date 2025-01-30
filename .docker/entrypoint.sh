#!/usr/bin/env sh

set -xe

# 檢查 WordPress 核心文件是否已下載，如果未下載則下載
if [ ! -f "/var/www/html/wp-load.php" ]; then
    wp core download --allow-root
fi

# 檢查 wp-config.php 是否存在，如果不存在則創建
if [ ! -f "/var/www/html/wp-config.php" ]; then
    wp config create --dbname=wordpress --dbuser=root --dbpass=pass --dbhost=database --allow-root
fi

# 檢查 WordPress 是否已安裝，如果未安裝則安裝
if ! wp core is-installed --allow-root; then
    wp core install --url=localhost --title="WordPress WooCommerce" --admin_user=admin --admin_password=admin --admin_email=admin@example.com --allow-root
fi

# 檢查 WooCommerce 插件是否已安裝，如果未安裝則安裝並啟用
if ! wp plugin is-installed woocommerce --allow-root; then
    wp plugin install woocommerce --activate --allow-root
fi

# 檢查 Redis Object Cache 插件是否已安裝，如果未安裝則安裝並啟用
if ! wp plugin is-installed redis-cache --allow-root; then
    wp plugin install redis-cache --activate --allow-root
fi

# 啟用 Redis Object Cache
# wp redis enable --allow-root

exec "$@"
