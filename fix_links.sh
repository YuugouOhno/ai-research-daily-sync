#!/bin/bash

# Hugo形式リンク修正スクリプト
echo "🔧 Hugo形式リンク修正開始..."

# 各abstract.mdファイルを手動で修正
for abstract_file in content/2025/*/abstract.md; do
    if [ -f "$abstract_file" ]; then
        date_dir=$(dirname "$abstract_file")
        date_name=$(basename "$date_dir")
        echo "📝 修正中: $date_name"
        
        # 一時ファイル作成
        temp_file=$(mktemp)
        
        # ファイルを読み込んで、Obsidianリンクを正しい相対パスに変換
        while IFS= read -r line; do
            if [[ $line =~ \[\[([^]]+)\]\] ]]; then
                # Obsidianリンクを検出
                title="${BASH_REMATCH[1]}"
                
                # 対応するファイル名を検索
                found_file=""
                for md_file in "$date_dir"/*.md; do
                    if [ -f "$md_file" ] && [[ "$(basename "$md_file" .md)" == "$title" || "$(basename "$md_file")" == "$title.md" ]]; then
                        found_file=$(basename "$md_file")
                        break
                    fi
                done
                
                if [ -n "$found_file" ]; then
                    # URLエンコードされたファイル名を生成
                    encoded_file=$(printf '%s\n' "$found_file" | sed 's/ /%20/g')
                    # リンクを置換
                    modified_line=$(echo "$line" | sed "s/\[\[$title\]\]/[$title](.\/$(printf '%s\n' "$found_file" | sed 's/[[\.*^$()+?{|]/\\&/g'))/g")
                    echo "$modified_line" >> "$temp_file"
                else
                    echo "$line" >> "$temp_file"
                fi
            else
                # 元記事リンクの修正
                if [[ $line =~ \[元記事:([^]]+)\] ]]; then
                    url="${BASH_REMATCH[1]}"
                    echo "$url" >> "$temp_file"
                else
                    echo "$line" >> "$temp_file"
                fi
            fi
        done < "$abstract_file"
        
        # 元ファイルを置換
        mv "$temp_file" "$abstract_file"
        echo "  ✅ $date_name 修正完了"
    fi
done

echo "✅ Hugo形式リンク修正完了!"