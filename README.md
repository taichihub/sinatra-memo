# Sinatra Memo App

## セットアップ手順

### ローカル環境にクローンするコマンド
```
git clone git@github.com:taichihub/sinatra-memo.git
```

### libpgをインストールするコマンド
postgreSQLサーバと通信するための公式Cライブラリ<br>
このライブラリを基にpgがRubyからPostgreSQLデータベースに接続する
```
brew install libpg
```

### libpgのパスを設定するコマンド
これにより、pgジェムのインストールプロセスがlibpgの位置を正確に把握し、適切にコンパイルできるようになる
```
brew --prefix libpq
```

### bundle install
```
bundle install
```

### PostgreSQLがインストールされてあるか確認
バージョン情報が出力されたらPostgreSQLはインストールされてある。<br>
バージョン情報が出力されなければPostgreSQLはインストールされていない。<br>
インストールされていない場合、後述の「PostgreSQLインストールコマンド」を実行する。
```
psql --version
```
出力例
```
psql (PostgreSQL) 14.12 (Homebrew)
```

### PostgreSQLインストールコマンド
🍺マークが出力されれば正常にインストールされたことになる。
```
brew install postgresql@14
```

### PostgreSQLサービス開始コマンド
```
brew services start postgresql@14
```

### システムのユーザー名検索コマンド
```
whoami
```

### PostgreSQLに接続するコマンド
「実際のユーザー名」の部分はwhoamiコマンドを打って出力されたユーザー名を代入する
```
psql -h localhost -U [実際のユーザー名] -d postgres
```

### ユーザーを作成するコマンド
```
CREATE ROLE root WITH LOGIN PASSWORD 'password';
```
(※)通常、ユーザー名・パスワードは自分の任意のものに決める
(※)今回はユーザー名=root, パスワード=passwordで進める

### データベースを作成する権限をrootユーザーに与えるコマンド
```
ALTER ROLE root CREATEDB;
```

### rootユーザーでPostgreSQLにログインするコマンド
```
psql -U root -d postgres
```

### memoappデータベースを作成するコマンド
```
CREATE DATABASE memoapp;
```
出力例
```
CREATE DATABASE
```

### データベースの存在を確認するコマンド
```
\l
```
出力例
```
postgres=> \l
                           List of databases
   Name    |  Owner  | Encoding | Collate | Ctype |  Access privileges  
-----------+---------+----------+---------+-------+---------------------
 memoapp   | root    | UTF8     | C       | C     | 
 postgres  | chiroru | UTF8     | C       | C     | 
 template0 | chiroru | UTF8     | C       | C     | =c/chiroru         +
           |         |          |         |       | chiroru=CTc/chiroru
 template1 | chiroru | UTF8     | C       | C     | =c/chiroru         +
           |         |          |         |       | chiroru=CTc/chiroru
```

### .envファイルに認証情報を記述
```
# データベース接続
DB_NAME=memoapp
DB_USER=root
DB_PASSWORD=password
DB_HOST=localhost
DB_PORT=5432

# データベース接続プール設定
DB_POOL_SIZE=10
DB_POOL_TIMEOUT=5
```
(※)通常は環境変数は公に見えるところには記述しないが、今回は練習のため例外

### rootユーザーで作成したmemoappデータベースに直接アクセスするコマンド
```
psql -U root -d memoapp;
```

### memoappテーブルの中にnotesテーブルを作成するコマンド
```
CREATE TABLE notes (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    content TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);
```
出力例
```
CREATE TABLE
```

### 作成するテーブル一覧を確認するコマンド
```
\dt
```
出力例
```
memoapp=> \dt
       List of relations
 Schema | Name  | Type  | Owner 
--------+-------+-------+-------
 public | notes | table | root
(1 row)

```

### notesテーブルの中のデータを確認するコマンド
```
SELECT * FROM notes;
```
出力例
```
memoapp=> SELECT * FROM notes;
 id |        title        |     content     |         created_at         |         updated_at         
----+---------------------+-----------------+----------------------------+----------------------------
  1 | メモ1のタイトルです | メモ1の内容です | 2024-08-02 19:30:51.776656 | 2024-08-02 19:30:51.776656
```

### ローカルサーバーを立ち上げるコマンド
```
ruby app.rb
```

### webで画面確認するためのURL
```
http://localhost:4567
```

### コード解析するコマンド
コードがコーディング規約に遵守されているかチェックを行うツール
```
rubocop
```

### erb_lintツール実行コマンド
erb_lintとは、rubocopではチェックできないerbファイルのスタイルをチェックするツール
```
bundle exec erblint --lint-all -a
```
(※)オプション「-a」を付けることによって、チェックだけでなく自動修正機能も備えることができる