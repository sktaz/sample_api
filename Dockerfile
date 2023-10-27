FROM ruby:3.2.2
# yarnをinstallするためのリポジトリーを取得
# https://classic.yarnpkg.com/en/docs/install#debian-stable
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# ライブラリをインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs postgresql-client yarn vim

ENV EDITOR=vim
WORKDIR /sample_api

# Docker内でGemfileに記載のライブラリをインストールする
COPY Gemfile /sample_api/Gemfile
COPY Gemfile.lock /sample_api/Gemfile.lock
RUN bundle install && bundle update
COPY . /sample_api

RUN bundle install && bundle update

RUN rm -f tmp/pids/server.pid
