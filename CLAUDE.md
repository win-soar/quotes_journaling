# Quotes Journaling - CLAUDE.md

## プロジェクト概要
名言の投稿・閲覧ができる SNS アプリ。LINE 連携による毎日のリコメンド配信機能を持つ。

## 技術スタック
- **バックエンド**: Rails 7.1.5.2 / Ruby 3.2.3
- **フロントエンド**: Hotwire (Turbo + Stimulus), Bootstrap 5.3, jsbundling-rails
- **DB**: PostgreSQL 15
- **認証**: Devise + OmniAuth (Google, LINE)
- **ファイルストレージ**: Cloudflare R2 (S3互換)
- **外部連携**: LINE Bot API, SendGrid
- **管理画面**: ActiveAdmin

## 開発環境の起動

```bash
docker-compose up -d        # バックグラウンド起動
docker-compose up           # ログを見ながら起動
docker-compose down         # 停止
docker-compose logs -f app  # アプリログ確認
```

アクセス: http://localhost:3000

## 主要ディレクトリ
- `app/models/` — quote, user, comment, like, report, line_notification
- `app/controllers/` — quotes, users, comments, likes, reports, rankings, scheduler, line_webhook
- `app/views/` — ERB テンプレート
- `spec/` — RSpec テスト (models/, views/, routing/)
- `config/routes.rb` — ルーティング定義
- `db/` — マイグレーション

## テスト実行

```bash
docker-compose exec app bundle exec rspec
```

## Lint

```bash
docker-compose exec app bundle exec rubocop
```

## 環境変数
`.env.development` に定義（Cloudflare R2, Google OAuth, LINE API, SendGrid, SECRET_KEY_BASE）

## デプロイ先
Render（本番環境）

## Claude への操作ガイドライン

### 原則的に避けること
- `.gitignore` に記載されているファイルの読み取り・参照
  （`.env.development`, `config/master.key`, `log/`, `tmp/`, `node_modules/` 等）
- PC・コンテナ・DB に広範な影響を与えるコマンド
  （例: `rm -rf`, `db:drop`, `git reset --hard`, `force push` 等）

### どうしても必要な場合のみ確認を入れること
上記の操作が作業上どうしても必要と判断した場合は、実行前に理由を説明し確認を求めること。
それ以外（通常のファイル読み書き・マイグレーション・テスト実行等）は確認なしに進めてよい。
