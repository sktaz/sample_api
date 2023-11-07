# README
Rails7で作成したAPIのサンプル。

## 初回セットアップ
- 0.「`.env`」ファイルをルートディレクトリに作成する

```
AUTH0_DOMAIN=https://自分のAuth0のドメイン.us.auth0.com
AUTH0_AUDIENCE=http://localhost:3001
```

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




## 2回目以降の起動
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


## Dockerで立ち上げたAPIにスマホからアクセスする方法

### 1.Windows Defenderのファイアウォールの許可設定
- コントロール パネル\システムとセキュリティ\Windows Defender ファイアウォール
で詳細設定を押下

- 受信の規則から新しい規則を作成
- ポートを指定し次へ
- TCPを選択し、特定のローカルポートに3001を入力し次へ
- 接続を許可するを選択し次へ
- ドメイン、プライベート、パブリックを選択して次へ。
- 規則の名前と説明を入力し完了ボタンを押下する。


### 2.ポートフォワーディング設定
### ローカルPCのIPアドレスを確認する
windowsの設定画面の「ネットワークとインターネット」から接続しているネットワークをクリック。
IPv4アドレスの値を確認する。

  <img src="https://storage.googleapis.com/zenn-user-upload/bb480083eb9f-20231107.png" width="40%">


### powershellで実行
- powershellを管理者として実行する

<img src="https://storage.googleapis.com/zenn-user-upload/5c40e0f73b36-20231107.png" width="30%">


- 設定前に現在のポートフォワード設定を確認する
  ```
  netsh interface portproxy show all
  ```


- netshコマンドでポートフォワードを設定を行なう。
  ```
  netsh interface portproxy add v4tov4 listenport={ローカルPCのリッスンポート} listenaddress={windowsの設定から確認したIPアドレス} connectport={Docker上で起動しているアクセスしたいアプリケーションのポート} connectaddress={DockerのIPアドレス}  
  ```

  たとえば、Dockerコンテナ上で、`rails s -b 0.0.0.0 -p 3001`で立ち上げる場合は、DockerのIPアドレスは0.0.0.0を指定する。

  ```
  # 例
  netsh interface portproxy add v4tov4 listenport=3001 listenaddress=172.28.72.28 connectport=3001 connectaddress=0.0.0.0
  ```

- ポートフォワード設定を確認し、設定がされていることを確認する
  ```
  netsh interface portproxy show all
  ```

  <img src="https://storage.googleapis.com/zenn-user-upload/a885b8100959-20231107.png" width="40%">


- 参考：設定を消す場合
  ```
  netsh interface portproxy reset
  ```

- 詳細は以下記事に記載しました  
  https://zenn.dev/ringo_to/articles/fe6467653fb0d7