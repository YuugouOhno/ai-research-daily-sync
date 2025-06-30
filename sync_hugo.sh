#!/bin/bash

# Hugo形式同期スクリプト
# 2025フォルダの記事をHugo互換形式に変換してcontentディレクトリに同期

echo "🔄 Hugo形式同期開始..."

# 同期対象の日付ディレクトリを取得
for date_dir in 2025/2025-*/; do
    if [ -d "$date_dir" ]; then
        date_name=$(basename "$date_dir")
        echo "📂 処理中: $date_name"
        
        # contentディレクトリに対応するディレクトリを作成
        mkdir -p "content/2025/$date_name"
        
        # abstract.mdが存在する場合、変換処理
        if [ -f "$date_dir/abstract.md" ]; then
            echo "  📝 abstract.md変換中..."
            
            # Obsidianリンクを相対パスに変換
            sed -E 's/\[\[([^]]+)\]\]/[\1](\.\//g; s/(\]\([^)]*) /\1%20/g; s/(\]\([^)]*)$/\1.md)/g; s/\[元記事:([^]]+)\]/\1/g' "$date_dir/abstract.md" > "content/2025/$date_name/abstract.md"
            
            echo "  ✅ abstract.md変換完了"
        fi
        
        # 個別記事ファイルをコピー
        for file in "$date_dir"/*.md; do
            if [ -f "$file" ] && [[ "$(basename "$file")" != "abstract.md" ]]; then
                cp "$file" "content/2025/$date_name/"
                echo "  📄 $(basename "$file") コピー完了"
            fi
        done
    fi
done

echo "✅ Hugo形式同期完了!"
echo "📊 変換結果:"
find content/2025 -name "*.md" | wc -l | xargs echo "  - 総ファイル数:"
find content/2025 -name "abstract.md" | wc -l | xargs echo "  - abstractファイル数:"