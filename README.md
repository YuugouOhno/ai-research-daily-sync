# AI Research Daily Sync

自動化された技術情報収集・要約システム

## 概要

このリポジトリは、AI・技術系ブログからの新着記事を自動収集し、構造化された要約を生成するシステムです。Claude Code環境で動作し、日次の情報収集ワークフローを完全自動化します。

## 主な機能

### 🔄 自動化ワークフロー
- **新着記事検出**: 設定されたソースから新しい記事を自動識別
- **内容取得・要約**: WebFetchを使用した詳細な記事分析
- **構造化出力**: 統一されたMarkdown形式での要約生成
- **統合サマリー**: 日次の全体サマリー作成

### 📊 情報源管理
- Google Research Blog
- Anthropic News
- Meta AI Blog
- OpenAI News
- Microsoft AI News
- その他追加可能

### 🛠 Claude Code統合
- カスタムコマンド (`/daily_full_sync`) での一括実行
- 段階的実行も可能な柔軟な設計
- 手動クリップコンテンツとの統合機能

## ファイル構造

```
catch_up/
├── .claude/
│   ├── commands/           # 実行コマンド定義
│   │   ├── daily_full_sync.md       # メインワークフロー
│   │   ├── daily_research_sync.md   # 新着記事収集
│   │   ├── fetch_and_summarize_today.md  # 記事要約生成
│   │   ├── process_clips_to_today.md     # 手動クリップ処理
│   │   └── generate_daily_abstract.md    # 統合サマリー生成
│   └── templates/          # 共通テンプレート
│       └── article_template.md     # 記事要約テンプレート
├── clips/                  # 手動クリップ一時保存
├── 2025/                   # 年別出力フォルダ
│   └── 2025-MM-DD/        # 日別フォルダ
│       ├── abstract.md    # 日次統合サマリー
│       ├── latest_blog.json  # 構造化データ
│       └── [記事タイトル].md # 個別記事要約
├── document_list.md        # 監視対象URL一覧
├── last_run.txt           # 最終実行日時
└── README.md              # このファイル
```

## 使用方法

### 前提条件
- Claude Code環境
- WebFetchツールへのアクセス
- 監視対象ブログへのアクセス権限

### 基本的な使用方法

1. **完全自動実行**
   ```
   /daily_full_sync
   ```
   全工程を一括実行（約6-9分）

2. **段階的実行**
   ```
   /daily_research_sync        # 新着記事収集
   /fetch_and_summarize_today  # 記事要約生成
   /process_clips_to_today     # 手動クリップ処理（条件付き）
   /generate_daily_abstract    # 統合サマリー生成
   ```

### カスタマイズ

#### 情報源の追加
`document_list.md`にURLを追加：
```markdown
# 新しいカテゴリ
https://example-tech-blog.com/feed
https://another-blog.com/rss
```

#### テンプレートの修正
`.claude/templates/article_template.md`を編集してMarkdown形式やWebFetchプロンプトをカスタマイズ

## 出力形式

### 個別記事要約
```markdown
---
title: "記事タイトル"
source: "https://..."
author: ["著者名", "組織名"]
published: 2025-MM-DD
created: 2025-MM-DD
description: "記事の概要"
tags: ["clippings"]
---

# 記事タイトル

## 概要
[3-4文での主要ポイント]

## 主要内容
[詳細な内容整理]

## 重要なポイント
- [ポイント1]
- [ポイント2]

## 所感・影響
[業界・技術への影響分析]
```

### 日次統合サマリー
- ソース別グループ化
- 各記事の1行要約
- 更新のないソースの記録

## 技術仕様

### 使用ツール
- **WebFetch**: 記事内容取得・要約生成
- **Read/Write**: ファイル操作
- **Bash**: 日付処理・ファイル管理
- **Glob/LS**: ファイル検索

### エラーハンドリング
- 部分的な失敗でも処理継続
- 詳細なエラーログ記録
- アクセス失敗時の自動スキップ

### パフォーマンス
- WebFetchの並列実行
- 増分更新（前回実行日以降のみ）
- 効率的なファイル操作

## 貢献・カスタマイズ

### 新機能の追加
1. `.claude/commands/`に新しいコマンドを追加
2. 必要に応じて`.claude/templates/`のテンプレートを更新
3. `document_list.md`に新しい情報源を追加

### 既知の制限事項
- WebFetchツールのレート制限
- 一部ブログのアクセス制限
- 大量記事処理時の時間制約

## ライセンス

MIT License

## 更新履歴

- **v1.0.0**: 基本的な情報収集・要約機能
- **v1.1.0**: 手動クリップ統合機能追加
- **v1.2.0**: テンプレート統一化・英語プロンプト対応

---

**開発者**: Claude Code + Human Collaboration
**最終更新**: 2025-06-30