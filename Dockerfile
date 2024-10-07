# ベースイメージとしてalpineを使用
FROM --platform=linux/arm/v7 bitnami/kubectl:latest

# 必要なパッケージをインストール
RUN apk add --no-cache \
    git \
    openssh-client

# 作業ディレクトリを設定
WORKDIR /git

# rolloutスクリプトを作成
COPY rollout.sh /usr/local/bin/rollout.sh
RUN chmod +x /usr/local/bin/rollout.sh

# エントリーポイントを設定
ENTRYPOINT ["/usr/local/bin/rollout.sh"]