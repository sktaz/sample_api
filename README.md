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


## Dockerで立ち上げたAPIにスマホからアクセスするための準備

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
powershell上で実行
- netshコマンドを実行
  ```
    netsh
  ```

- ポートフォワーディングを行う(netshコマンド実行後に打つ)
interface portproxy add v4tov4 listenport={ローカルPCのリッスンポート} listenaddress={ローカルPCのIPアドレス} connectport={Dockerのポート} connectaddress={DockerのIPアドレス}  
  ※DockerのIPアドレスは0.0.0.0を指定。
  ```
  interface portproxy add v4tov4 listenport=3001 listenaddress=123.123.1.123 connectport=3001 connectaddress=0.0.0.0
  ```



- 設定内容を確認
  ```
  interface portproxy show v4tov4
  ```

- 設定を消す場合
  ```
  interface portproxy reset
  ```