# project cards tasks  
カード型プロジェクト＆タスク管理アプリ   
https://project-cards-tasks.herokuapp.com/  

（サーバ上のアプリケーションは自由に操作していただいて問題ありません。なお、サーバがheroku無料プランで動作しているため、アプリケーションの起動に時間がかかる場合があります。）  

![アプリ画像](https://user-images.githubusercontent.com/3204814/60413009-5b7e7480-9c0e-11e9-8965-fea7cef20f7f.png)

![アプリ画像](https://user-images.githubusercontent.com/3204814/60413010-5c170b00-9c0e-11e9-9911-0f80d01da1b7.png)

## アプリケーションの目的
Ruby/Rails実務経験約1年の私が、Ruby/Railsで書くコードを具体的に示すために作成したポートフォリオサイトです。  

## アプリケーションの説明
プロジェクトごとにカード単位でタスクを管理できるwebアプリケーションです。  

複数のユーザで使用することを想定しています。ユーザは自由にプロジェクトを作り他のユーザを招待して、招待されたユーザはプロジェクトに参加することができます。  

プロジェクトのオーナーと参加したユーザは、プロジェクトの中にカードとして複数のタスクを作成して、カードを自由に並べて管理することができます。カードには名前の他に担当者や期限の設定ができます。  

各プロジェクトにはログが設定されており、カードの作成、編集、削除、アサインなどの操作が記録されます。また、カードの指定期日になった場合や期日が過ぎた場合には、その内容がログとして記録されます。

## 環境
* Ruby 2.6.3 
* Rails 5.2.3
* DB PostgreSQL 11.3
* javascript
* Heroku （Cloudinary、Heroku Schedulerアドオン使用）

## 使用した主なgem
* Webpacker 4.0.2
* ActiveStorage 5.2.3
* Omniauth 1.9.0
* Slim 4.0.1
* ActiveDecorator 1.2.0
* kaminari 0.17.0
* FactoryBot 5.0.2
* Rspec 3.8.0

## 使用した主なnpmパッケージ
* Bootstrap 4.3.1
* Fontawesome 5.8.2

## ER図
![ER図](https://user-images.githubusercontent.com/3204814/60411391-87e2c280-9c07-11e9-984a-91f933696e9c.png)

## 主な機能
* SNS認証
* マイページ画像アップロード
* プロジェクト、カラム、カードのCRUD機能
* カラム、カードの移動機能
* ユーザ検索、招待、参加、お知らせ機能
* ログ機能
* 定期処理（1日1回、期日に関するログを生成）
* 退会処理

## 権限について 
プロジェクトのオーナー、参加者、それ以外のユーザで、プロジェクトに対して実行可能な操作が異なります。  

プロジェクトのオーナーは以下の操作が可能です  
- プロジェクトの一覧表示・詳細表示・編集・削除、他のユーザの招待  
- カラムとカードの作成・編集・移動・削除  

プロジェクトの参加者は以下の操作が可能です  
- プロジェクトの一覧表示・詳細表示  
- カラムとカードの作成・編集・移動・削除  

それ以外のユーザは以下の操作が可能です  
- プロジェクトの一覧表示

## ユーザ退会時の処理について
退会するユーザがオーナーをしているプロジェクトがある場合、そのプロジェクトに参加者がいれば、一番古い参加者が代わってプロジェクトのオーナーになります。プロジェクトに参加者がいない場合は、プロジェクトは削除されます。

## コードの設計について
### モデルのロジック共通化について
モデルの主要な目的ではない処理で複数のモデルで汎用的に使えるロジックについては、`app/models/concerns` に置いて共通化しています。  
リモートの画像をモデルに添付処理するモジュール <a href="https://github.com/katanoZ/project_cards_tasks/blob/develop/app/models/concerns/remote_file_attachable.rb">RemoteFileAttachable</a> を共通処理として作成しました。モジュールの `#attachment_target` メソッドでモデルと添付ファイルとを紐付けします。モジュールをincludeするモデル側
で `#attachment_target` メソッドをオーバーライドするよう強制しています。（テンプレートメソッドパターン）

### サービスクラス
ユーザ退会時の処理として、`Users` コントローラの `#destroy` アクションから、サービスクラス <a href="https://github.com/katanoZ/project_cards_tasks/blob/develop/app/services/deregistration_manager.rb">DeregistrationManager</a> を呼び出して処理を実行しています。  
オーナー交代やログ出力などの「退会処理」というユースケースの処理を一括してクラス内で扱うこと、複数モデルに対する処理を一括して扱うことを意図しています。

### フォームクラス
プロジェクトで他のユーザを検索して招待するフォームで、フォームクラス<a href="https://github.com/katanoZ/project_cards_tasks/blob/develop/app/forms/invitation_form.rb"> InvitationForm
 </a>を使用しています。  
モデルと紐付かないフォームでユーザ入力項目のバリデーションを行うこと、フォームで使用する検索機能をフォームクラスを使って呼び出すことを意図しています。

### 権限の管理
「権限について」項目で記述したように、プロジェクトに対してユーザがアクセスできる範囲を管理しています。  
gemを使って管理するやり方ではなく、コントローラでモデルのインスタンスを生成する際に生成できる範囲を制限しています。例えば <a href="https://github.com/katanoZ/project_cards_tasks/blob/develop/app/controllers/cards_controller.rb">CardsController</a> の `#set_project` では `.accessible` スコープを通してプロジェクトのインスタンスを取得しています。  
```
@project = Project.accessible(current_user).find(params[:project_id])
```
上記によって、ブラウザのURL直接入力など通常範囲外のアクセスで実行ユーザのアクセス権がない場合は、`#find` で例外が発生して `404 Not Found` エラーとして処理されるようにしています。  
（`403 Forbidden` エラーとして処理される方が意味的に正しいかもしれないですが、アクセス権がないページの存在自体を知らせない目的を兼ねて `404 Not Found` で処理するサービスもGithubなど一般的に存在するため、それに倣う形にしました。）

### コールバッククラス 
カード、カラムなどモデルのコールバックでログを出力しています。コールバックに関する処理をモデルから分離するため、それぞれのモデルから `app/callbacks` 以下のクラスに処理を委譲しました。

### decoratorとhelperの使い分け
ビューの表示に関するロジックについては、個別のモデルに依存するものはdecoratorに、個別のモデルに依存しないもの（共通のflashメッセージにあてるcssクラス生成など）はhelperに記述しました。

### 定数の記述場所
モデル全体に関する定数はモデルの <a href="https://github.com/katanoZ/project_cards_tasks/blob/develop/app/models/application_record.rb">ApplicationRecord</a> に、個々のモデルに関する定数はそのモデルに記述しています。  
アプリケーション全体に関する定数は <a href="https://github.com/katanoZ/project_cards_tasks/blob/develop/config/initializers/constants.rb">`config/initializers/constants.rb`</a> に記述しています。

### バリデーション
モデル共通で使用するカスタムバリデータは、`app/validators` 以下に置いています。  
各モデル固有のカスタムバリデーションメソッドは、各モデル内に実装しています。

### 定期処理
Heroku Schedulerアドオンを使用しました。カードの期日に関するログを出力するため、1日1回毎日00:00(JST)にRakeタスク <a href="https://github.com/katanoZ/project_cards_tasks/blob/develop/lib/tasks/log_due_date.rake">log:due_date</a> を実行してログを出力します。

### テストについて
RSpecを使用しました。クラスメソッド、インスタンスメソッド、スコープ、rakeタスクの単体テストを `spec/` 以下に作成しています。  
コントローラの動作については、リクエストスペックでレスポンスを検証しました。

## 設計についての参考文献
コードの設計については、主に以下の書籍2冊を参考にしました。  
- オブジェクト指向設計実践ガイド ~Rubyでわかる 進化しつづける柔軟なアプリケーションの育て方（技術評論社）
- 現場で使える Ruby on Rails 5速習実践ガイド（マイナビ出版）

## ローカルでの実行手順
1. リポジトリをローカルにクローン  
```
git clone git@github.com:katanoZ/project_cards_tasks.git
```

2. 必要なGemをインストール  
```
bundle install
```

3. javascriptパッケージ群のインストール
```
yarn install
```

4. データベースを設定  
```
rails db:create
rails db:migrate
```

5. アプリの起動  
```
bundle exec foreman start
```
上記コマンドで起動。（ポートはデフォルトで5000）  
railsとwebpackerのプロセスが同時に立ち上がります。
