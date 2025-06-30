# Fetch and Summarize Today Command

This command processes articles from latest_blog.json and creates individual summary files for each article.

## Process:
1. Read latest_blog.json to get list of articles
2. Use WebFetch to get detailed content for each article URL
3. Generate individual summary files following the established template format
4. Organize files in the YYYY/YYYY-MM-DD/ folder structure
5. Update abstract.md with new articles if needed

## Execution:
The command should fetch content, analyze publication dates, and create appropriately organized summary files with structured Japanese format and source attribution.