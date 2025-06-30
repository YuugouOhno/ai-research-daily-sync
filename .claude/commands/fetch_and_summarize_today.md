# Step2: 記事詳細取得・要約・まとめ生成コマンド

latest_blog.jsonから各記事の詳細内容を取得し、個別要約ファイルとabstract.mdを生成します。

## 実行手順

1. **今日の日付取得とファイル確認**
   - 今日の日付（YYYY-MM-DD）を取得
   - `YYYY/YYYY-MM-DD/latest_blog.json` の存在確認

2. **JSONデータ読み込み**
   - latest_blog.jsonから構造化データを読み込み
   - JSON形式で記事情報を解析
   - ブログ名、タイトル、URL、公開日情報を取得

3. **記事内容取得と個別要約生成**
   - 各URLに対してWebFetchツールでフルコンテンツを取得
   - `.claude/templates/article_template.md`の形式に従って要約生成
   - WebFetchプロンプトはテンプレートファイルを参照

4. **個別記事ファイル生成**
   - 各記事を `YYYY/YYYY-MM-DD/[記事タイトル].md` として保存
   - **形式**: `.claude/templates/article_template.md`で定義された統一形式を使用
   - ファイル名は適切な文字に変換

5. **処理結果出力**
   - 取得成功/失敗の件数
   - 生成されたファイル一覧
   - エラーがある場合は詳細

## 使用ツール
- **Bash**: 日付取得とファイル名処理
- **Read**: latest_blog.jsonの読み込み
- **WebFetch**: 各記事の詳細内容取得
- **Write**: 個別要約ファイルとabstract.mdの生成

## エラー処理
- URLアクセスに失敗した場合はスキップし、エラーログを記録
- ファイル名に使用できない文字は自動的に置換
- 重複するファイル名の場合は連番を追加

---

**実行開始**: 上記の手順に従って記事詳細取得・要約生成を実行してください。
**次のステップ**: `/generate_daily_abstract` で今日のabstract.mdファイルを生成