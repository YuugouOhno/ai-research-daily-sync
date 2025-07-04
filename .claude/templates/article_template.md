# 記事要約テンプレート

## Markdownファイル形式

個別記事ファイルは以下の統一形式で生成してください：

```markdown
---
title: "[記事タイトル]"
source: "[URL]"
author:
  - "[[著者名]]"
  - "[[組織名]]"
published: YYYY-MM-DD
created: YYYY-MM-DD
description: "[記事の概要を1-2文で簡潔に]"
tags:
  - "clippings"
---

# [記事タイトル]

## 概要
[記事の主要なポイントを3-4文で説明]

## 主要内容
[記事の内容を記事の構造に沿って要約。記事の特性に応じて適切な見出しで整理]

## 重要なポイント
- [ポイント1]
- [ポイント2]
- [ポイント3]

## 所感・影響
[記事が業界や読者に与える影響、重要性について]
```

## WebFetchプロンプト

記事内容取得時は以下の詳細プロンプトを使用：

```
Please analyze this article content thoroughly and provide a comprehensive Japanese summary with the following structure:

**Analysis Guidelines:**
- Include all technical details, experimental procedures, results, and analysis without omission
- Reconstruct the content in a readable format, not just a summary
- Use natural, readable Japanese prose
- Accurately record important numbers, data, and proper nouns
- Maintain the article's logical structure and flow

**Output Structure (in Japanese):**
1. 概要 (Overview): Main points in 3-4 sentences
2. 主要内容 (Main Content): Detailed breakdown following article structure
   - Background and objectives
   - Key technical details
   - Experimental/research methodology
   - Specific results and data
   - Author's analysis and insights
3. 重要なポイント (Key Points): List format
4. 所感・影響 (Impact & Implications): Technical and industry significance

Also extract: article title, author information, publication date.
Output all content in Japanese.
```

## ファイル命名規則

- **ファイル名**: `[記事タイトル].md`
- **特殊文字の置換**:
  - `/` → `-`
  - `?` → `_`
  - `:` → ` -`
  - `|` → ` -`
  - `*` → `_`
  - `<>` → `_`
  - `"` → `'`
- **保存場所**: `YYYY/YYYY-MM-DD/[記事タイトル].md`

## メタデータ抽出ルール

### 新着記事の場合
- title: WebFetchで取得した記事タイトル
- source: 元のURL
- author: 記事から抽出した著者・組織情報
- published: 記事の公開日
- created: 処理実行日

### clipsファイル変換の場合
- title: 既存のtitle値を保持
- source: 既存のsource値を保持
- author: 既存のauthor値を保持
- published: 既存のpublished値を保持
- created: 処理実行日で上書き

## 要約作成ガイドライン

1. **概要**: 記事の核心を3-4文で簡潔に
2. **主要内容**: 記事の論理構造に沿って整理
3. **重要なポイント**: 実用的・技術的に重要な点をリスト化
4. **所感・影響**: 業界・技術トレンドへの影響を分析

## インテリジェントタグ付けルール

### 新着記事用タグ
- **ソース別タグ**: ブログソース名に基づく自動タグ
  - Google Research → `google-research`, `research-paper`
  - Anthropic → `anthropic`, `claude`, `ai-safety`
  - Meta AI → `meta-ai`, `social-media-ai`
  - OpenAI → `openai`, `gpt`, `chatgpt`
  - Microsoft AI → `microsoft-ai`, `azure-ai`
  - VentureBeat → `industry-news`, `business-ai`
- **内容別タグ**: 記事内容から推定される技術分野タグ
  - AI研究論文: `research-paper`, `academic`
  - 製品発表: `product-launch`, `announcement`
  - 技術解説: `technical-guide`, `tutorial`
  - 業界分析: `industry-analysis`, `market-trend`
  - セキュリティ: `security`, `privacy`
  - プログラミング: `programming`, `development`
  - データサイエンス: `data-science`, `machine-learning`
- **汎用タグ**: 全ての記事に共通
  - `clippings` (必須)
  - `ai` (AI関連記事の場合)
  - `tech-news` (技術ニュースの場合)

### 手動クリップ用タグ
- **必須タグ**: `selfclip`, `clippings`
- **ソース別タグ**: URLドメインから推定
  - qiita.com → `qiita`, `japanese-tech`
  - zenn.dev → `zenn`, `japanese-tech`
  - note.com → `note`, `japanese-blog`
  - github.com → `github`, `open-source`
  - youtube.com → `youtube`, `video-content`
  - twitter.com/x.com → `twitter`, `social-media`
- **内容別タグ**: 記事タイトルと内容から推定
  - MCP関連: `mcp`, `claude-integration`
  - ChatGPT/Claude関連: `chatgpt`, `claude`, `ai-assistant`
  - プログラミング: `programming`, `development`
  - フロントエンド: `frontend`, `javascript`, `react`
  - バックエンド: `backend`, `api`, `database`
  - DevOps: `devops`, `deployment`, `ci-cd`
  - 機械学習: `machine-learning`, `data-science`
- **日本語コンテンツタグ**: `japanese-content` (日本語記事の場合)

## 品質基準

- 日本語での要約（元記事言語問わず）
- 技術的正確性の維持
- 簡潔性と詳細性のバランス
- 一貫したトーン・文体
- 適切なタグ付け（上記ルールに従って）

---

このテンプレートは `fetch_and_summarize_today.md` と `process_clips_to_today.md` で共通使用されます。