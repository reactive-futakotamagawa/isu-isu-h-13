# ISUCON用 ansible

## 必要

- Ansible
  - `init`を実行するためには、`community.general.git_config`、`community.general.github_deploy_key`、`prometheus.prometheus.node_exporter`のモジュールが必要。`ansible-galaxy collection install community.general`、`ansible-galaxy collection install prometheus.prometheus`でインストールできる。
- Python3系
  - Ansibleを動かすのに必要。

## 使い方

### リポジトリを用意する

```sh
source ./bin/init.sh {ディレクトリ名} {サーバーの数} {Makefile版を使う場合は-m}
```

で必要なディレクトリ構成ができる。

```txt
.
├── Makefile
├── s1
│   └── etc
│       ├── mysql
│       │   └── .gitkeep
│       ├── nginx
│       │   └── .gitkeep
│       └── systemd
│           └── system
│               └── .gitkeep
├── s2
│   └── etc
│       ├── mysql
│       │   └── .gitkeep
│       ├── nginx
│       │   └── .gitkeep
│       └── systemd
│           └── system
│               └── .gitkeep
└── s3
    └── etc
        ├── mysql
        │   └── .gitkeep
        ├── nginx
        │   └── .gitkeep
        └── systemd
            └── system
                └── .gitkeep
```

GitHubに上げておく。

### 変数を設定する

#### `./vars/vars.yml`

見えていい変数。

<details>

```yml
---
## 事前に設定する部分
webhook_url: {webhookのURL}

github:
  repo_url: {リポジトリURL}
  repo_name: {リポジトリ名}

deploy_branch: {デフォルトのブランチ}

## 当日サーバーに入って設定する部分

project_root: {ルートフォルダ(git管理するリポジトリ)}

nginx:
  conf_dir:
    original: {nginxの設定フォルダ(/etc/nginx)}
    repo: {コピー先("{{ project_root }}/{{ server_id }}/etc/nginx")}
  access_log_file: {アクセスログのファイル(/var/log/nginx/access.log)}
  service_name: {systemdのサービス名}

db:
  conf_dir:
    original: {mysqlの設定フォルダ(/etc/mysql)}
    repo: {コピー先("{{ project_root }}/{{ server_id }}/etc/mysql")}
  slow_log_file: {スローログファイル(/var/log/mysql/mysql-slow.log)}
  service_name: {systemdのサービス名}

app:
  service_name: {アプリのサービス名}
  dir: {Goのプログラムが入ったディレクトリ("{{ project_root }}/webapp/golang")}
  bin: {アプリのバイナリ("{{ project_root }}/webapp/golang/app")}

go_path: {Goのパス}

env_file: 
  original: {環境変数ファイル(/home/isucon/env.sh)}
  repo: {コピー先({{ project_root }}/{{ server_id }}/env.sh")}

systemd:
  conf_dir:
    original: {systemdの設定フォルダ。変更しなくていいはず(/etc/systemd/system)}
    repo: {コピー先("{{ project_root }}/{{ server_id }}/etc/systemd/system")}

```

</details>

#### `ansible/vars/secrets.yml`

見えちゃダメな変数。必要になるのは`0_init`の実行時のみ。
GitHubのアクセストークンは"administration"と"contents"と"deploymentes"にRead/Writeの権限が必要。

<details>

```yml
github_secrets:
  user_name: {GitHubのユーザー名(ikura-hamu)}
  repo_owner: {GitHubのリポジトリのオーナー(reactive-futakotamagawa)}
  token: {GitHubのアクセストークン} #こいつは絶対見えちゃダメ
```

</details>

#### `ansible/hosts.yml`

ホストの設定。

<details>

```yml
---
# ansible hosts
all:
  hosts:
    {IPアドレス}: #全部乗ってるサーバー
      server_id: s1
  children:
    app: #アプリが乗ってるサーバー
      hosts:
        {IPアドレス}:
          server_id: s2
    db: #DBが乗ってるサーバー
      hosts:
        {IPアドレス}:
          server_id: s3
    proxy: #nginxが乗ってるサーバー
      hosts:
        {IPアドレス}:
          server_id: s2 #app+nginxのサーバーだったらこんな感じに書く
```

</details>

### 実行

#### 初期化

- ツールのインストール
- Gitの設定
- GitHubリポジトリのセットアップ(コミット・プッシュはしない)

```sh
ansible-playbook -i ansible/hosts.yml ansible/playbooks/0_init.yml
```

#### デプロイ

- git pull
- DB、nginx、アプリの再起動
- ログローテーション

```sh
ansible-playbook -i ansible/hosts.yml ansible/playbooks/1_deploy.yml
```

ブランチを指定

```sh
ansible-playbook -i ansible/hosts.yml ansible/playbooks/1_deploy.yml -e "deploy_branch={ブランチ名}"
```

Makefileの方を使う場合は、`1_deploy.yml`を`2_make_deploy.yml`にする。
