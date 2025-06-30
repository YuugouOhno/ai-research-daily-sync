# メインコマンド: 日次情報収集フルワークフロー

今日の情報収集を完全自動化するメインコマンドです。以下の5つの個別コマンドを順次実行します：

## 実行する個別コマンド

### Step 1: 新着記事収集
**コマンド**: `/daily_research_sync`
- `document_list.json`から情報源URLを読み込み
- `last_run.txt`との比較で新着記事を特定
- WebFetchで各ソースの最新記事を取得
- `latest_blog.json`として構造化データを生成
- `last_run.txt`を今日の日付で更新

### Step 2: 記事詳細取得・要約生成
**コマンド**: `/fetch_and_summarize_today`
- `latest_blog.json`から各記事URLを読み込み
- WebFetchで記事の詳細内容を取得
- 各記事を個別要約ファイルとして生成
- ファイル形式: `YYYY/YYYY-MM-DD/[記事タイトル].md`

### Step 3: 手動クリップ処理（条件付き）
**コマンド**: `/process_clips_to_today`
- `clips/`フォルダ内の`.md`ファイル存在をチェック
- **ファイルが存在する場合のみ**以下を実行：
  - 既存メタデータを抽出
  - 新テンプレート形式に変換
  - 今日のフォルダに移動
  - 元のclipsファイルを削除

### Step 4: 日次まとめ生成
**コマンド**: `/generate_daily_abstract`
- 今日生成された全個別記事ファイルを読み込み
- ソース別にグループ化
- `abstract.md`として統合サマリーを生成

### Step 5: Hugo同期・デプロイ
**コマンド**: `/sync_to_hugo`
- 今日のコンテンツをHugo互換形式に変換
- Obsidianリンク→相対リンク変換
- Hugo用インデックスファイル生成
- Git操作（add → commit → push）
- GitHub Actions自動デプロイ完了まで

## 実行手順

**重要**: このコマンドは以下の5つの個別コマンドを順次実行します。各コマンドのエラー時は詳細を記録し、可能な限り処理を継続します。

### 1. Step 1: 新着記事収集
```
コマンド実行: daily_research_sync
```
- document_list.json読み込み
- last_run.txt基準日取得
- 各情報源のWebFetch並列実行
- latest_blog.json生成
- last_run.txt更新

### 2. Step 2: 記事詳細処理
```
コマンド実行: fetch_and_summarize_today
```
- latest_blog.json解析
- 各記事のWebFetch並列実行
- 個別要約ファイル生成
- テンプレート形式での統一生成

### 3. Step 3: clips処理（条件分岐）
```
コマンド実行: process_clips_to_today
```
- clips/フォルダの.mdファイル存在確認
- 存在する場合：
  - 各ファイル読み込み・変換
  - 今日フォルダへ移動
  - 元ファイル削除
- 存在しない場合：処理スキップ

### 4. Step 4: 統合サマリー生成
```
コマンド実行: generate_daily_abstract
```
- 今日フォルダ内の全.mdファイル読み込み
- ソース別グループ化
- abstract.md生成

### 5. Step 5: Hugo同期とデプロイ
```
コマンド実行: sync_to_hugo + Git操作
```
- 今日のコンテンツをHugo形式に変換・同期
- Obsidianリンクを相対リンクに変換
- インデックスファイル生成
- 全ての変更をステージング（git add -A）
- 日次同期用のコミットメッセージ生成
- ローカルリポジトリにコミット
- GitHubリモートリポジトリにプッシュ
- GitHub Actionsによる自動デプロイトリガー

### 6. 処理結果レポート
- 各ステップの成功/失敗状況
- 生成ファイル一覧
- Hugo同期結果
- Git操作結果
- デプロイURL
- エラー詳細（あれば）

## 使用ツール
- **Bash**: 日付取得、フォルダ操作、ファイル削除、Git操作
- **Read**: 設定ファイル・記事ファイル読み込み
- **Write**: JSON・Markdownファイル生成
- **WebFetch**: 記事内容取得
- **Glob/LS**: ファイル検索・一覧取得
- **Edit**: Hugo形式リンク変換

## エラーハンドリング
- 各ステップでエラーが発生した場合は詳細を記録
- 部分的な失敗でも継続可能な処理は続行
- 最終レポートでエラー箇所を明示

## 実行時間目安
- Step 1: 2-3分（WebFetch並列処理）
- Step 2: 3-4分（記事詳細取得）
- Step 3: 30秒-1分（clips処理、条件次第）
- Step 4: 30秒（統合処理）
- Step 5: 30秒（Hugo同期）
- Step 6: 30秒（Git操作・プッシュ）
- **合計**: 約7-10分（デプロイ完了まで）

---

## 実行方法

**Step 1: 新着記事収集**
```bash
コマンド実行: daily_research_sync
```

**Step 2: 記事詳細取得・要約生成**  
```bash
コマンド実行: fetch_and_summarize_today
```

**Step 3: 手動クリップ処理**
```bash
コマンド実行: process_clips_to_today
```

**Step 4: 日次まとめ生成**
```bash
コマンド実行: generate_daily_abstract
```

**Step 5: Hugo同期・デプロイ**
```bash
コマンド実行: sync_to_hugo
```

最後に：
- git add -A
- git commit（自動メッセージ生成）
- git push origin main
- GitHub Actions自動デプロイ

---

**実行開始**: 上記の5つのコマンドを順次実行して日次情報収集の完全自動化を実行してください。

## 完全自動化フロー
```
daily_research_sync → fetch_and_summarize_today → process_clips_to_today → generate_daily_abstract → sync_to_hugo → Git Push → GitHub Actions → サイト公開
```

**注意事項**:
- 各コマンドは前のコマンドの完了を待ってから実行
- エラー時は詳細ログを記録して処理継続
- 大量のWebFetch実行のため、適度な間隔での実行を推奨
- **最終的にサイト更新まで完全自動実行**

**完了時の成果物**:
- 新着記事の個別要約ファイル（fetch_and_summarize_today）
- clips統合ファイル（process_clips_to_today）
- 統合サマリー（generate_daily_abstract）
- Hugo互換のWebサイト構造（sync_to_hugo）
- GitHub上の更新されたリポジトリ
- 公開されたWebサイト: https://yuugouohno.github.io/ai-research-daily-sync