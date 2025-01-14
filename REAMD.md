# Wordpress & WooCommerce

在 local 用 nginx + php-fpm 跑 Wordpress + WooCommerce

## 創建步驟

1. 啟動 Docker 服務

    ```bash
    docker compose up -d --build
    ```

2. 在 Docker container 下載 WordPress

    ```bash
    docker compose exec -it wordpress bash
    wp core download --allow-root
    wp config create --dbname=wordpress --dbuser=root --dbpass=pass --dbhost=database --allow-root
    wp core install --url=localhost --title="WordPress WooCommerce" --admin_user=admin --admin_password=admin --admin_email=admin@example.com --allow-root
    ```

3. 安裝 WooCommerce plugin

    ```bash
    wp plugin install woocommerce --activate --allow-root
    ```
