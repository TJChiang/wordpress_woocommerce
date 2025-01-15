# Wordpress & WooCommerce

在 local 用 nginx + php-fpm 跑 Wordpress + WooCommerce

## 壓力測試

### Apache Bench

#### 首頁

```bash
ab -n 1000 -c c http://localhost/
```

|  | 總請求數 | 失敗請求數 | 並發數 | 請求平均時間 (ms) | 並發請求平均時間 (ms) | 總測試時間 (s) | 每秒請求數 (#/s) |
| -- | -- | -- | -- | -- | -- | -- | -- |
| 1 | 1000 | 0 | 1 | 40.07 | 40.07 | 40.07 | 24.96 |
| 2 | 1000 | 0 | 50 | 453.49 | 9.07 | 9.07 | 110.26 |
| 3 | 1000 | 0 | 100 | 920.78 | 9.21 | 9.21 | 108.6 |
| 4 | 1000 | 0 | 200 | 1810.14 | 9.05 | 9.05 | 110.49 |

#### 商品頁

```bash
ab -n 1000 -c c http://localhost/product/sample-product/
```

|  | 總請求數 | 失敗請求數 | 並發數 | 請求平均時間 (ms) | 並發請求平均時間 (ms) | 總測試時間 (s) | 每秒請求數 (#/s) |
| -- | -- | -- | -- | -- | -- | -- | -- |
| 1 | 1000 | 0 | 1 | 40.84 | 40.84 | 40.84 | 24.49 |
| 2 | 1000 | 0 | 50 | 9.28 | 463.75 | 9.28 | 107.82 |
| 3 | 1000 | 0 | 100 | 948.64 | 9.49 | 9.49 | 105.41 |
| 4 | 1000 | 0 | 200 | 1869.86 | 9.35 | 9.35 | 106.96 |

## 創建步驟

### 自動步驟

```bash
docker compose up -d
```

### 手動步驟
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
