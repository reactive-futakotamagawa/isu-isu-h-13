#SERVER_ID:=ansibleでは自動で指定する。

#変数
PROJECT_ROOT:=/home/isucon/private_isu
APP_DIR:=$(PROJECT_ROOT)/webapp/go

APP_SERVICE:=isu-go
APP_BIN:=$(APP_BIN)/app

DB_SERVICE:=mysql
DB_CONF_ORIGINAL:=/etc/mysql
DB_CONF_REPO:=$(PROJECT_ROOT)/$(SERVER_ID)/etc/mysql

NGINX_SERVICE:=nginx
NGINX_CONF_ORIGINAL:=/etc/nginx
NGINX_CONF_REPO:=$(PROJECT_ROOT)/$(SERVER_ID)/etc/nginx

SLOW_LOG_FILE:=/var/log/mysql/mysql-slow.log
ACCESS_LOG_FILE:=/var/log/nginx/access.log

.PHONY: check-id
check-id: ## SERVER_IDが指定されているかチェック
ifndef SERVER_ID
	@echo "SERVER_ID is undefined"
	exit 1
endif

#まとめる(ansibleで使う)
.PHONY: all
all: check-id db-nocheck nginx-nocheck app-nocheck ## 全部やる

.PHONY: db
db: check-id db-nocheck ## DBの設定を反映、スロークエリログを削除、再起動

.PHONY: nginx
nginx: check-id nginx-nocheck ## NGINXの設定を反映、アクセスログを削除、再起動

.PHONY: app
app: check-id app-nocheck ## アプリケーションのビルド、再起動

#チェックなし
.PHONY: db-nocheck
db: rm-slow-log set-db-conf ## DBの設定を反映、スロークエリログを削除、再起動

.PHONY: nginx-nocheck
nginx: rm-access-log set-nginx-conf ## NGINXの設定を反映、アクセスログを削除、再起動

.PHONY: app-nocheck
app: build restart ## アプリケーションのビルド、再起動

#要素
.PHONY: set-db-conf
set-db-conf: ## dbの設定を反映、再起動
	sudo cp -r $(DB_CONF_REPO)/* $(DB_CONF_ORIGINAL)
	sudo systemctl restart $(DB_SERVICE)

.PHONY: set-nginx-conf
set-nginx-conf: ## NGINXの設定を反映、再起動
	sudo cp -r $(NGINX_CONF_REPO)/* $(NGINX_CONF_ORIGINAL)
	sudo systemctl restart $(NGINX_SERVICE)

.PHONY: rm-slow-log
rm-slow-log: ## スロークエリのログローテーション（削除してるだけ）
	sudo chmod 777 $(SLOW_LOG_FILE)
	sudo truncate $(SLOW_LOG_FILE) -s 0 -c

.PHONY: rm-access-log
rm-access-log: ## アクセスログのログローテーション（削除してるだけ）
	sudo chmod 777 $(ACCESS_LOG_FILE)
	sudo truncate $(ACCESS_LOG_FILE) -s 0 -c

.PHONY: restart
restart: ## アプリケーション再起動
	sudo systemctl restart $(APP_SERVICE)

.PHONY: build
build: ## アプリケーションのビルド
# PGOを使う
	cd $(APP_DIR) && go build -o $(APP_BIN)
