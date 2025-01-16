# Wordpress & WooCommerce

在 local 用 nginx + php-fpm 跑 Wordpress + WooCommerce

## Apache Bench 壓力測試

### 首頁

```bash
ab -n 1000 -c c http://localhost/
```

|  | 總請求數 | 失敗請求數 | 並發數 | 請求平均時間 (ms) | 並發請求平均時間 (ms) | 總測試時間 (s) | 每秒請求數 (#/s) |
| -- | -- | -- | -- | -- | -- | -- | -- |
| 1 | 1000 | 0 | 1 | 40.07 | 40.07 | 40.07 | 24.96 |
| 2 | 1000 | 0 | 50 | 453.49 | 9.07 | 9.07 | 110.26 |
| 3 | 1000 | 0 | 100 | 920.78 | 9.21 | 9.21 | 108.6 |
| 4 | 1000 | 0 | 200 | 1810.14 | 9.05 | 9.05 | 110.49 |

### 商品頁

```bash
ab -n 1000 -c c http://localhost/product/sample-product/
```

|  | 總請求數 | 失敗請求數 | 並發數 | 請求平均時間 (ms) | 並發請求平均時間 (ms) | 總測試時間 (s) | 每秒請求數 (#/s) |
| -- | -- | -- | -- | -- | -- | -- | -- |
| 1 | 1000 | 0 | 1 | 40.84 | 40.84 | 40.84 | 24.49 |
| 2 | 1000 | 0 | 50 | 9.28 | 463.75 | 9.28 | 107.82 |
| 3 | 1000 | 0 | 100 | 948.64 | 9.49 | 9.49 | 105.41 |
| 4 | 1000 | 0 | 200 | 1869.86 | 9.35 | 9.35 | 106.96 |

## k6 壓力測試

## 可能出現的瓶頸

- 資料庫查詢：WooCommerce 查詢過多，尤其是在商品頁和購物車頁面。
- PHP 解釋速度：PHP 腳本的執行時間過長，特別是繁重的插件。
- 靜態資源加載：CSS、JS 和圖片等靜態資源未優化，導致頁面加載速度變慢。
- External Calls：外部 API 請求造成阻塞。

## 待實踐優化方式

- 啟用 OPcache：大幅提升 PHP 性能
- 資料庫查詢快取：減少重複查詢
- 靜態資源壓縮：減少頁面加載時間
- 使用 CDN：提升全球資源加載速度
- 使用 ElasticSearch：提升商品搜尋功能的效能
- 使用 Nginx FastCGI Cache 作為前端快取層。
- 使用 ElasticSearch 或 Algolia 來優化商品搜尋功能。
- 啟用 HTTP/2 以提升靜態資源的傳輸效率。
- 使用 ImageMagick 來壓縮圖片。

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
