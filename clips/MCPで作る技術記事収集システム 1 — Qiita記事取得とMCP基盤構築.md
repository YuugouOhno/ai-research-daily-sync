---
title: "MCPで作る技術記事収集システム #1 — Qiita記事取得とMCP基盤構築"
source: "https://qiita.com/ruumalilja/items/6714a99d2dc454f984cf"
author:
  - "[[ruumalilja]]"
published: 2025-06-22
created: 2025-06-30
description: "前回の構想編に続き、今回はいよいよ実装編です。Model Context Protocol（MCP）を使ってQiita記事を取得し、Claude Desktopと連携する基盤を構築します。 1. はじめに — 構想から実装へ 前回の構想編では、技術記事収集システム..."
tags:
  - "clippings"
---
![](https://relay-dsp.ad-m.asia/dmp/sync/bizmatrix?pid=c3ed207b574cf11376&d=x18o8hduaj&uid=3126516)

前回の構想編に続き、今回はいよいよ実装編です。Model Context Protocol（MCP）を使ってQiita記事を取得し、Claude Desktopと連携する基盤を構築します。

## 1\. はじめに — 構想から実装へ

前回の [構想編](https://qiita.com/ruumalilja/items/da1c0f6254f64fcb0ff1) では、技術記事収集システムの全体像をお話ししました。

今回は **Phase 1** として、その第一歩となる基盤を構築します。Claude Desktopで「今週のReact記事を3件教えて」と話しかけるだけで、Qiitaから人気記事を自動取得してくれる仕組みを作りました。

### Phase 1の実装範囲

- **MCP Server基本構築** （Node.js + JSON-RPC over STDIO）
- **Qiita API連携** （期間・カテゴリフィルタ対応）
- **Claude Desktop統合** （設定ファイル1つで完了）
- **スコアリング機能** （いいね数 + ストック数による人気度算出）

軽量でAIエージェントとの親和性が高いMCPの威力を、実際に体感できる実装になりました。

## 2\. 完成形

まずは完成形をお見せします。従来なら「Qiitaを開く → 検索 → フィルタ設定 → 結果をコピー」という手順が必要でしたが、 **自然言語での一言指示** で完了します。

### Claude Desktopでの実際の操作

**ユーザー**: "qiitaでおすすめのAIに関する記事を3つ紹介して"

**Claude（MCPサーバーの回答例）**:

```text
📈 人気記事 TOP3

1. ChatGPT API活用術：効率的なプロンプト設計とコスト削減のコツ
   👍 84  📚 102 (score: 288)
   2025/6/18 14:32:15
   https://qiita.com/demo_user_ai/items/example-chatgpt-api

2. LangChainで作るRAGシステム実装ガイド
   👍 67  📚 89 (score: 245)
   2025/6/17 09:45:22
   https://qiita.com/demo_user_ml/items/example-langchain-rag

3. 機械学習モデルの本番運用で学んだ10の教訓
   👍 52  📚 73 (score: 198)
   2025/6/16 16:28:41
   https://qiita.com/demo_user_data/items/example-ml-production
```

[![tech-collector-mcp.gif](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F3687993%2F454594b9-a426-49e6-bfde-f557fa28aee3.gif?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=a55fe8106d658054cc2adf578bd1685f)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F3687993%2F454594b9-a426-49e6-bfde-f557fa28aee3.gif?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=a55fe8106d658054cc2adf578bd1685f)

いかがでしょうか？MCPの「USB感覚」での利用が実現できています。

## 3\. 実装のハイライト

### MCPサーバーの核心実装

```javascript
// MCPサーバーの核心部分（src/index.js抜粋）
process.stdin.on('data', async (chunk) => {
  for (const line of chunk.trim().split('\n')) {
    const msg = JSON.parse(line);
    const { id, method, params } = msg;
    
    if (method === 'tools/call' && params.name === 'get_qiita_ranking') {
      const ranking = await getQiitaRankingText(params.arguments);
      sendResponse(makeResult(id, { content: [{ type: 'text', text: ranking }] }));
    }
  }
});
```

従来なら複雑なWebサーバー構築が必要だった機能が、 **Node.jsプロセス1つで完結** しています。JSON-RPC over STDIOによる軽量実装がMCPの魅力です。

### 柔軟な検索クエリ構築

```javascript
// 期間とカテゴリに応じた動的クエリ生成（src/services/qiitaRanking.js抜粋）
let query = \`created:>${dateFilter}\`;
if (period === 'daily') query += ' stocks:>0';
if (period === 'weekly') query += ' stocks:>5';
if (period === 'monthly') query += ' stocks:>10';
if (category) query += \` tag:${category}\`;

// スコアリングで本当に価値のある記事を抽出
const score = item.likes_count * SCORE_WEIGHT.like + item.stocks_count * SCORE_WEIGHT.stock;
```

期間に応じて品質フィルタを調整し、 **本当に価値のある記事** だけを抽出する仕組みです。

## 4\. 実装の深掘り — JSON-RPC over STDIOの魅力

### 軽量性の秘密

MCPサーバーは標準入出力でやり取りするため、従来のWebサーバーと比べて圧倒的に軽量です：

```javascript
// エラーハンドリングも含めたシンプルな実装
try {
  const msg = JSON.parse(line);
  const { id, method, params } = msg;
  
  if (method === 'tools/call') {
    const result = await handleToolCall(params);
    sendResponse(makeResult(id, result));
  }
} catch (err) {
  sendErrorResponse(id, -32000, err.message);
}
```

### スコアリングアルゴリズムの工夫

単純にいいね数順ではなく、期間に応じて重み付けを調整：

```javascript
// 期間別の品質フィルタ
const FILTERS = {
  daily: 'stocks:>0',    // 1日: ストック1以上
  weekly: 'stocks:>5',   // 1週間: ストック5以上  
  monthly: 'stocks:>10'  // 1ヶ月: ストック10以上
};

// ストック重視のスコアリング（ストック=保存価値）
const score = likes * 1 + stocks * 2;
```

この仕組みにより、 **一時的な話題性** だけでなく **継続的に参考にされている質の高い記事** を抽出できます。

### セットアップ

詳細な手順は [GitHubリポジトリ](https://github.com/ruumalilja/tech-collector-mcp) をご覧ください。  
基本的には：

1. `git clone`  →  `npm install`
2. Claude Desktop設定ファイルにMCPサーバーのパスを追加
3. 再起動で完了

設定が成功すると、Claude Desktopでこのような表示になります：

[![スクリーンショット 2025-06-21 222001.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3687993/3d9f378c-fd0d-461c-b9ae-566ca5a123c6.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F3687993%2F3d9f378c-fd0d-461c-b9ae-566ca5a123c6.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=0d3aea330aafc87043310bab4fcab8df)

`get_qiita_ranking` ツールが利用可能になっていることが確認できます。前回説明した「USB感覚」での利用が実現できます。

## 5\. 実際の活用シーン

### 朝の情報収集ルーチン

- "昨日のJavaScript記事で人気のものは？"
- "今週のTypeScript記事を5件、スコア順で"

### 技術選定の参考

- "Reactの週間人気記事を3件"
- "Vue.jsとAngularの月間トップ記事を比較して"

### 学習計画の立案

- "初心者向けのPython記事を今月のトップから"
- "Docker記事で上級者向けのものを探して"

「今週のReact記事を3件」といった **曖昧な指示** も、MCPサーバーが適切に解釈して実行してくれます。従来のAPI開発では考えられない柔軟性です。

## 6\. 次のステップ

### Phase 2予告: Gemini API要約機能

次回Phase 2では、Gemini APIを本格活用した要約機能で「記事収集 → AI要約」の流れを完成させる予定です。

実装予定の機能：

- 記事本文の自動取得
- 技術記事に特化した要約プロンプト
- 要約レベルの調整機能（短い/詳細）

### 今後の展開

- **Phase 3**: マルチソース対応（複数技術メディア・RSS統合）
- **Phase 4**: チーム共有・ナレッジ管理（Slack/Discord Bot・Notion/Obsidian連携）
- **Phase 5**: パーソナライゼーション（学習履歴に基づく推薦）

## 8\. おわりに

構想編で描いた技術記事収集システムの第一歩が完成しました。

MCPを使ってみて改めて感じるのは、従来なら複雑だった機能が簡単に実現できることです。まさに「USB感覚」でAIエージェントに新しい能力を追加できる時代になりました。

技術記事の収集・要約・共有が全自動化されることで、エンジニアの学習効率とチーム連携が劇的に改善されるはずです。

次回の要約機能実装で、さらに実用的なシステムに進化させていきます。

## 参考リンク

### 🔗 関連リンク

- 📚 [作成中MCPサーバー（GitHub）](https://github.com/ruumalilja/tech-collector-mcp)
- 🔗 [前回記事: MCPで作る技術記事収集システム #0 — 構想編](https://qiita.com/ruumalilja/items/da1c0f6254f64fcb0ff1)
- 🔗 [Model Context Protocol公式](https://modelcontextprotocol.io/)
- 🔗 [Qiita API v2ドキュメント](https://qiita.com/api/v2/docs)

### 📖 デモで使用された記事（参考文献）

以下は記事作成時のデモで実際に表示された記事です。投稿者の皆様に感謝いたします：

1. **【AI駆動開発】Cursorを使いこなして1ヶ月でプログラミング学習サイトを作ったのでノウハウを伝えたい**
	- 投稿者: [@tomada](https://qiita.com/tomada/items/efce0e3b3dfb033663ef)
	- 👍 211 📚 212 (score: 635)
2. **【コピペOK】個人開発でApple風デザインルールを作ったら統一感のあるカッコいいUIにできた話**
	- 投稿者: [@tomada](https://qiita.com/tomada/items/decece613046a61b11a3)
	- 👍 128 📚 125 (score: 378)
3. **もう手書きは不要！？React開発にStorybookとCopilotを導入して、爆速でUIを編集・確認する方法**
	- 投稿者: [@yu\_720](https://qiita.com/yu_720/items/62769dd4e5e12e022b63)
	- 👍 27 📚 17 (score: 61)
4. **AIコーディングツールとパフォーマンスチューニングを始める際のTIPS**
	- 投稿者: [@morry\_48](https://qiita.com/morry_48/items/f4fd80b5bb66b7ac1a12)
	- 👍 13 📚 11 (score: 35)
5. **マイクロソフトCEOが言った”AIでSaaSアプリの消滅する”に関して**
	- 投稿者: [@QueryPie](https://qiita.com/QueryPie/items/6c20485284f22a35ef73)
	- 👍 13 📚 8 (score: 29)

本記事は 2025年6月時点の情報に基づいています。API仕様やClaude Desktopの設定方法は変更される可能性があります。

**デモについて**: 記事中のデモで表示されている具体的な記事タイトルや内容は、撮影時点（2025年6月）のQiita実データを使用しています。

---

**続編公開**: Phase 2として、Gemini APIを本格活用した記事要約機能を実装しました！

記事タイトルだけでは分からない「内容の価値」を、URLひとつで瞬時に把握できるシステムが完成しています。

👉 [MCPで作る技術記事収集システム #2 — Gemini API要約機能](https://qiita.com/ruumalilja/items/ede8c1ec01f960ad43a2)

構想編で描いた「記事収集 → AI要約」の流れをぜひご覧ください！

[0](https://qiita.com/ruumalilja/items/#comments)

コメント一覧へ移動

[11](https://qiita.com/ruumalilja/items/6714a99d2dc454f984cf/likers)

7