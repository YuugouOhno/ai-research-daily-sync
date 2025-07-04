# Step3: 日次まとめファイル（abstract.md）生成コマンド

今日生成された個別記事ファイルを参照して、統一された日次まとめファイルを生成します。

## 実行手順

1. **今日の日付確認**
   - 今日の日付（YYYY-MM-DD）を取得
   - `YYYY/YYYY-MM-DD/` フォルダの存在確認

2. **個別記事ファイルの読み込み**
   - 対象フォルダ内の `.md` ファイル（latest_blog.json以外）をすべて検索
   - 各ファイルのメタデータ（title, source, description）を抽出
   - 記事の要約内容も参照

3. **ソース別グループ化**
   - latest_blog.json の構造を参照してソース別に整理
   - 各ソースの記事を適切にグループ化

4. **abstract.md生成**
   - 以下の形式でファイルを生成（ブログ化対応）：
   ```markdown
   ## [ソース名1]
   ### [[記事タイトル]]
   [日本語での簡潔な説明]
   [元記事](URL)
   
   ## [ソース名2]  
   ### [[記事タイトル]]
   [日本語での簡潔な説明]
   [元記事](URL)
   
   ## 更新のなかったブログ
   - [更新なしのソース名]

   ## 参考文献
   本日の更新サマリは以下の情報源を基に作成されました：
   - [各ソース名]
   - 各記事の個別要約ファイル
   ```

5. **ファイル保存**
   - `YYYY/YYYY-MM-DD/abstract.md` として保存
   - 既存ファイルがある場合は上書き

## 使用ツール
- **Bash**: 今日の日付取得
- **Glob**: 個別記事ファイルの検索
- **Read**: 各ファイルのメタデータと内容読み込み
- **Write**: abstract.mdファイルの生成

## エラー処理
- 個別記事ファイルが存在しない場合は警告を表示
- メタデータが不完全なファイルはスキップ
- 処理結果を最後に報告

---

**実行開始**: 上記の手順に従って日次まとめファイルを生成してください。