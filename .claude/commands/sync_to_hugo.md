# Hugo形式同期コマンド（当日分）

当日（今日）のフォルダのみをHugo互換形式に変換してcontentディレクトリに同期します。

## 実行手順

1. **当日ディレクトリ確認**
   - 今日の日付（YYYY-MM-DD）を取得
   - `2025/YYYY-MM-DD/` フォルダの存在確認
   - フォルダ内の `.md` ファイルを特定

2. **ファイルフィルタリング**
   - `selfclip` タグを含むファイルは除外
   - frontmatterで `tags` に `selfclip` が含まれるファイルをスキップ

3. **ファイル変換処理**
   - **個別記事ファイル**: ファイル名を日付+ID形式に変更 (`YYYYMMDD-001.md`, `YYYYMMDD-002.md` など)
   - **abstract.md**: Obsidianリンク `[[記事名]]` → Hugo相対リンク `[記事名](./YYYYMMDD-xxx.md)`
   - **その他ファイル**: そのままコピー（変換なし）
   - 元記事URL形式を統一: `[元記事:URL]` → `URL`

4. **contentディレクトリ同期**
   - `content/2025/YYYY-MM-DD/` に構造を維持してコピー
   - 既存ファイルは上書き更新

5. **変換ルール**
   ```markdown
   # ファイル名変換
   変換前: Steijn - オランダの食事計画を変革するAIアシスタント.md
   変換後: 20250701-001.md
   
   # abstract.mdのリンク変換
   変換前: [[Steijn - オランダの食事計画を変革するAIアシスタント]]
   変換後: [Steijn - オランダの食事計画を変革するAIアシスタント](./20250701-001/)
   
   # 結果のHugo URL
   実際のURL: https://yuugouohno.github.io/ai-research-daily-sync/2025/2025-07-01/20250701-001/
   ```

## 実装

以下の処理を自動実行:

1. 今日の日付を取得（date +%Y-%m-%d）
2. 対象ディレクトリ `2025/YYYY-MM-DD/` をスキャン
3. 各 `.md` ファイルのfrontmatterをチェック
4. `selfclip` タグがないファイルのみ処理対象とする
5. **個別記事ファイル名の変更**:
   - 元ファイル名と新ファイル名のマッピングを作成
   - `YYYYMMDD-001.md`, `YYYYMMDD-002.md` の形式で連番付与
6. **abstract.md のリンク変換**:
   - `[[記事タイトル]]` → `[記事タイトル](./YYYYMMDD-xxx/)` に変換（Hugo URL形式）
   - マッピング情報を使用して正しいファイル名にリンク
   - 最終的なURL: `https://yuugouohno.github.io/ai-research-daily-sync/2025/YYYY-MM-DD/YYYYMMDD-xxx/`
7. `content/2025/YYYY-MM-DD/` に変換済みファイルをコピー
8. **Hugoインデックスファイル生成**:
   - `content/_index.md` - サイト全体のインデックス
   - `content/2025/_index.md` - 年別インデックス
   - `content/2025/YYYY-MM-DD/_index.md` - 日別インデックス
9. 処理結果レポートを出力

## 除外条件
- frontmatterの `tags` に `selfclip` が含まれるファイル
- `latest_blog.json` などの非markdownファイル

---

**実行開始**: 上記の手順に従って今日のフォルダをHugo形式に同期してください。