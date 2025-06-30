# Step1: 新着記事リスト生成コマンド

document_list.mdの各URLから新着記事のタイトルとURLを抽出し、構造化されたlatest_blog.mdを生成します。

## 実行手順

1. **前回実行日の確認**
   - `last_run.txt` から前回実行日を取得（存在しなければ初回扱い）
   - 今日の日付で新しいフォルダ `YYYY/YYYY-MM-DD/` を作成

2. **URL収集とコンテンツ取得**
   - `document_list.json` を読み込み
   - `_disabled` セクションはスキップ
   - 各URLに対してWebFetchツールでコンテンツを取得
   - RSS/Atom フィードがある場合は優先的に使用

3. **新着判定**
   - 各記事の公開日時を前回実行日と比較
   - 前回実行日より新しいものを「新着」と判定

4. **構造化データ生成**
   - 新着記事のタイトルとURLを抽出
   - `latest_blog.json` にJSON形式で保存
   - 個別記事の詳細取得は次のコマンドで実行

5. **ファイル形式**
   - **latest_blog.json**:
     ```json
     {
       "date": "2025-06-30",
       "sources": {
         "Google Research Blog": [
           {
             "title": "REGEN: Empowering personalized recommendations with natural language",
             "url": "https://research.google/blog/regen-empowering-personalized-recommendations-with-natural-language/",
             "published": "2025-06-27"
           }
         ],
         "Anthropic News": [
           {
             "title": "Introducing the Anthropic Economic Futures Program",
             "url": "https://www.anthropic.com/news/introducing-the-anthropic-economic-futures-program",
             "published": "2025-06-27"
           },
           {
             "title": "How People Use Claude for Support, Advice, and Companionship",
             "url": "https://www.anthropic.com/news/how-people-use-claude-for-support-advice-and-companionship",
             "published": "2025-06-27"
           }
         ],
         "Meta AI Blog": [
           {
             "title": "Modeling natural conversational dynamics with Seamless Interaction",
             "url": "https://ai.meta.com/blog/seamless-interaction-natural-conversational-dynamics/",
             "published": "2025-06-27"
           }
         ],
         "Microsoft AI News": [
           {
             "title": "Steijn: The AI assistant transforming meal planning for millions in the Netherlands",
             "url": "https://news.microsoft.com/source/emea/features/steijn-the-ai-assistant-transforming-meal-planning-for-millions-in-the-netherlands/",
             "published": "2025-06-30"
           }
         ]
       },
       "no_updates": ["OpenAI News"]
     }
     ```

5. **実行後処理**
   - `last_run.txt` を今日の日付で更新
   - 処理結果をコンソールに出力（新着数・エラー数など）
   - 次のステップ（fetch_and_summarize_today）の案内

## 使用ツール
- **Read**: `document_list.json` と `last_run.txt` の読み込み
- **WebFetch**: 各URLからタイトルとURL情報の取得
- **Write**: latest_blog.jsonの生成
- **Bash**: 日付フォルダの作成

## エラー処理
- 取得に失敗したURLは警告表示してスキップ
- 新着記事がない場合は空のセクションとして記録
- 処理は継続し、最後に実行ログを表示

---

**実行開始**: 上記の手順に従って新着記事リスト生成を実行してください。
**次のステップ**: `/fetch_and_summarize_today` で個別記事の詳細要約を実行