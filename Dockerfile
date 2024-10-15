# ベースイメージとしてalpineを使用
FROM --platform=linux/arm/v7 arm32v7/golang:1.23.2-alpine3.20

# 必要なパッケージをインストール
RUN apk add --no-cache \
    git \
    openssh-client \
    curl \
    bash

# pressly/gooseをインストール
RUN git clone https://github.com/pressly/goose && \
    cd goose && \
    go mod tidy && \
    go build -ldflags="-s -w" -tags='no_clickhouse no_libsql no_mssql no_mysql no_sqlite3 no_vertica no_ydb' -o goose ./cmd/goose

# gooseを/go/binに移動    
RUN mv goose/goose /go/bin

# kubectlをインストール
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.24.4/bin/linux/arm/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# 作業ディレクトリを設定
WORKDIR /git

# rolloutスクリプトを作成
COPY rollout.sh /usr/local/bin/rollout.sh
RUN chmod +x /usr/local/bin/rollout.sh

# エントリーポイントを設定
ENTRYPOINT ["/usr/local/bin/rollout.sh"]