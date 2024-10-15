#!/bin/sh

# Githubの環境変数設定
REPO_URL=${REPO_URL:-"https://github.com/your/repository.git"}
BRANCH=${BRANCH:-"main"}
POLL_INTERVAL=${POLL_INTERVAL:-30}
DEPLOYMENT=${DEPLOYMENT:-"your-deployment"}

# Postgresの環境変数設定
POSTGRES_HOST=${POSTGRES_HOST:-"your-postgres"}
POSTGRES_PORT=${POSTGRES_PORT:-"5432"}
POSTGRES_DB=${POSTGRES_DB:-"your-db"}
POSTGRES_USER=${POSTGRES_USER:-"your-user"}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-"your-password"}

# Gooseの環境変数設定
GOOSE_DRIVER=${GOOSE_DRIVER:-"postgres"}
GOOSE_DB=${GOOSE_DB:-"host=${POSTGRES_HOST} port=${POSTGRES_PORT} user=${POSTGRES_USER} password=${POSTGRES_PASSWORD} dbname=${POSTGRES_DB}"}

# 初期クローン
git clone --branch ${BRANCH} ${REPO_URL} src

# 無限ループでポーリング
while true; do
    cd src
    git fetch origin ${BRANCH}
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u})
    if [ $LOCAL != $REMOTE ]; then
        echo "Changes detected, restart deployment"
        
        # git pull
        git pull origin ${BRANCH}

        # migrationの実行
        cd migrations
        goose up
        cd ..

        # deploymentの更新
        kubectl rollout restart deployment ${DEPLOYMENT}
    else
        echo "No changes detected"
    fi
    cd ..
    sleep ${POLL_INTERVAL}
done