# README
Rails7で作成したAPIのサンプル。

##　初回セットアップ

- 0. `.env`ファイルをルートディレクトリに作成する

# Auth0のAPIs
AUTH0_DOMAIN=https://自分のAuth0のドメイン.us.auth0.com
AUTH0_AUDIENCE=http://localhost:3001


- 1.ローカルPCのターミナル上で実行し、bashを起動する
``` 
docker-compose build
docker-compose up -d
docker-compose exec web bash

```

- 2.ライブラリのインストール(bashで実行)
```
bundle install
```

- 3.データベースの作成
```
rails db:create
```


- 4.APIサーバーの起動(bash上で実行)
```
rails s -b 0.0.0.0 -p 3001
```




##　初回セットアップ以降の起動
- 1.ローカルPCのターミナル上で実行し、bashを起動する
``` 
docker-compose build
docker-compose up -d
docker-compose exec web bash

```

- 2.ライブラリのインストール(bashで実行)
```
bundle install
```

- 3.APIサーバーの起動(bash上で実行)
```
rails s -b 0.0.0.0 -p 3001

```