#!/bin/sh

# 環境変数の設定
REPO_URL=${REPO_URL:-"https://github.com/your/repository.git"}
BRANCH=${BRANCH:-"main"}
POLL_INTERVAL=${POLL_INTERVAL:-30}
DEPLOYMENT=${DEPLOYMENT:-"your-deployment"}

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
        git pull origin ${BRANCH}
        kubectl rollout restart deployment ${DEPLOYMENT}
    else
        echo "No changes detected"
    fi
    cd ..
    sleep ${POLL_INTERVAL}
done