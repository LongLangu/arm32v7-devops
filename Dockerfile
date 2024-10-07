# ベースイメージとしてalpineを使用
FROM --platform=linux/arm/v7 alpine:3.18

# 必要なパッケージをインストール
RUN apk add --no-cache \
    git \
    openssh-client \
    curl \
    bash

# kubectlをインストール
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm/v7/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# 作業ディレクトリを設定
WORKDIR /git

# rolloutスクリプトを作成
COPY rollout.sh /usr/local/bin/rollout.sh
RUN chmod +x /usr/local/bin/rollout.sh

# エントリーポイントを設定
ENTRYPOINT ["/usr/local/bin/rollout.sh"]