---
title: "Claude Codeの問題解決能力の底上げを試みる：MCPサーバー + subagents"
source: "https://zenn.dev/oikon/articles/82c9a52dc45810"
author:
  - "[[Zenn]]"
published: 2025-06-14
created: 2025-06-30
description:
tags:
  - "clippings"
---
169

71

Oikonです。外資IT企業でエンジニアをしています。

Claude Codeを趣味の個人開発でも日々使っていますが、Webアプリ開発の際にClaudeがライブラリのバージョンに依存する複雑な問題を解決できないケースが何回かありました。

試行錯誤をした結果、 **Model Context Protocol (MCP)サーバーをClaude Codeが使えるようにしてあげると、以前よりも問題解決能力が上がったため共有します** 。

使用したMCPサーバー：

- **Context7**
- **Brave-Search**

どちらも有名なMCPサーバーで特に新しいものではありません。今回はClaude Codeに明示的に使ってもらうことでWebアプリの問題を解決してもらいました。

これに加えて、 **カスタムスラッシュコマンドでsubagentにMCPサーバーを利用してもらう方法も試してみました** 。

すでにこれらのMCPサーバーやsubagentを使用されている方も多いと思いますが、この記事では改めて紹介したいと思います。

## Model Context Protocol (MCP)サーバー

![](https://storage.googleapis.com/zenn-user-upload/77d299107477-20250610.png)

MCPはAnthropic社が提案したAIとツールを繋ぐプロトコルです。

平たく言えば、 **AIエージェントが外部ツールを使えるようにするための規格** です。2025年6月現在ではかなり普及している印象で、今後のAIエージェントに欠かせない技術となっています。

今回はMCPについて深く踏み込みませんが、上の図と照らし合わせると以下のようになります。

- Host with MCP client = **Claude Code**
- MCP server A/C = **Context7 MCP server**
- MCP server C = **Brave-Search MCP server**

MCPサーバーについて、それぞれ簡単に見ていきます。

### ① Context7 MCP

Context7はUpstashが開発した **バージョン付きAPIドキュメントを取得するMCPサーバー** です。

Web開発現場では日々OSSライブラリのバージョンが上がり、AIモデルが持っている情報が古いものになります。Context7はその問題を解決するために公式ドキュメント情報を提供します。

具体的なライブラリ例は、以下の画像のようなものが挙げられます。

![](https://storage.googleapis.com/zenn-user-upload/bfbf05221e76-20250613.png)

これらは [context7のサイト](https://context7.com/) でも確認可能です。見てわかる通り一般的なWeb開発のライブラリ情報は入っていると思います。

MCPサーバーの設定方法も簡単です。ここではClaude Codeでの例を紹介します。

**Remote MCP Server for Claude Code**:

```bash
claude mcp add --transport sse context7 https://mcp.context7.com/sse
```

**Local MCP Server for Claude Code**:

```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp
```

Brave-Searchは **Web検索ツールのMCPサーバー** です。

Claude CodeにもWeb Search機能が標準でついていますが、個人的にあまり効果を感じにくかったのと、後述するsubagentにMCPツールの使用を頼みやすかったため、Brave-Searchを最近は使ってみています。

余談ですが、Claude CodeはそもそもBrave-Searchを内部的に使用しているような話も [Tech Crunchの記事](https://techcrunch.com/2025/03/21/anthropic-appears-to-be-using-brave-to-power-web-searches-for-its-claude-chatbot/) に書かれています。

Freeプランでは月間2,000クエリまで使用できます。APIキーは [公式サイト](https://brave.com/ja/search/api/) から取得してください。

私はClaude Desktopの設定からMCPサーバー設定を `claude mcp add-from-claude-desktop` で移行しました。CLIだと以下のコマンドでBrave-Search MCPサーバーを追加できるみたいです。

```bash
claude mcp add brave-search -s user -- env BRAVE_API_KEY=\`YOUR_API_KEY_HERE\` npx -y @modelcontextprotocol/server-brave-search
```

## Claude Code subagent (サブエージェント)

**subagentはClaude Codeにデフォルトで存在している機能です。**

意外と知らない人も多いと思いますが、 `Task` で表示されているものはsubagentが実行しています。Web FetchやReadは積極的にsubagentを使っている印象です。

Claude Codeのsubagentは [Anthropic公式ドキュメント](https://www.anthropic.com/engineering/claude-code-best-practices) にも明記されています。以下引用：

> This is the part of the workflow where you should consider strong use of **subagents**, especially for complex problems. Telling Claude to use **subagents** to verify details or investigate particular questions it might have, especially early on in a conversation or task, tends to preserve context availability without much downside in terms of lost efficiency.

ここでは **FileのReadなどの分割タスクは、subagentを使うこと推奨する** ということを伝えています。使い方は"use subagent"と明記してくれれば、subagentにタスクを振ってくれるのが良いです。

Claude Codeで起動したsubagentは以下のような特徴があります。

- 軽量
- 並列起動可能
- 親agentで使用可能なツールを使える
- subagentは独自のContext Windowを持つ
- 単独のタスクで動作し完了すると解放される

つまり、 **親agentがsubagentにタスクを与えて実行してもらうことができます** 。

subagentを複数使うことでタスクを並列実行できることも強みです。Anthropicの [How we built our multi-agent research system](https://www.anthropic.com/engineering/built-multi-agent-research-system) の中でも、ClaudeのDeep Researchにはmultiple-subagentが使用されていることが言及されています。

![The multi-agent architecture in action: user queries flow through a lead agent that creates specialized subagents to search for different aspects in parallel](https://storage.googleapis.com/zenn-user-upload/3169df8ba2c6-20250614.png)

今回はsubagentに２種類のMCPサーバーを使用してもらうことで、Claude Code内での簡易的なsubagent検索システムを試してみました。

## Claude Codeのsubagentに２つのMCPサーバーを使わせる

### subagentを使用しないケース

![](https://storage.googleapis.com/zenn-user-upload/9e819dc2c108-20250613.png)

**まずはsubagentの使用を明示的に指定していないケースです** 。

画像からわかるように、Context7とBrave-SearchのMCPサーバーが呼ばれています。

この時、 `CLAUDE.md` に以下のような文言を入れていました。

**CLAUDE.md：**

```md
\`use brave-search\`
```

今回はNext.js 15のHydration errorを試しに直してもらっています。Claude Code単独では上手く直せなかった問題ですが、この例では検索から上手くNext.js 15とMaterialUIの問題を調べてきて直してくれました。

subagentを使用しない場合のメリットは、 **Claude CodeのContextが完全に引き継がれた状態で問題解決方法を調べること** だと思います。

一方で、調査のためにMCPサーバーを使用することで、 **通常よりもContext windowを圧迫している印象を受けました** 。レートリミットに到達するまでが体感的に早かったです

### subagentの使用するケース

![](https://storage.googleapis.com/zenn-user-upload/c0f0ed71d7bc-20250613.png)

subagentを使用する場合は、プロンプトに" **use subagent（サブエージェントを使って）** "などの文言を入れます。" **multiple subagent** "を指定すると複数subagentのインスタンス（Task）を立ち上げてくれます。

上記の画像でも、multiple subagentがそれぞれ `Context7` と `Brave-Search` を使用しています。（なぜかもう一つsubagentが立ち上がっていますが）

subagentを使用する利点は以下のように考えています。

- **並列処理による情報圧縮**
- **AIエージェントの関心の分離**
- **親Claude CodeのContext Windowを圧迫しない**

一方で、親Claude CodeのContextのsubagentへの共有は最小限のように見えたため、期待した検索結果を返してこないケースもありました。

### Claude CodeでMCPサーバーを使うメリット・デメリット

Claude Codeの問題解決能力をMCPサーバーによる最新情報による補完で解決する方法について、個人的に感じたメリット・デメリットを記載します。

**メリット（Pros）** ：

- 実装がとても簡単
- RAGシステムが不要
- AIに最新情報を与えられる

**デメリット（Cons）** ：

- Contextを圧迫する
- Tokenをそれなりに食う
- Claude CodeがMCPサーバーを使うのが下手

私のケースではMCPサーバーによる最新情報の取得は効果がありましたが、生成AIゆえにある程度は出力ガチャの要素があります。 **コードガチャの排出確率を上げるために、MCPサーバーを使うようなイメージであれば問題ないと思います** 。

またsubagentにタスクを依頼することで、MCPサーバーを使うデメリットをある程度軽減できると考えています。

## 応用：カスタムスラッシュコマンドでバグ解決をすぐにお願いする

実はいちいち `use subagent` とか `use Context7` をプロンプト内で指示するのが面倒です。

個人的に **カスタムスラッシュコマンドでバグ解決のためのコマンドを仕込むのがおすすめ** です。

設定はとても簡単で、以下のフォルダにCommand用のMarkdownファイルを置くだけでできます。

MacOSの場合：

- global設定： `~/.claude/commands/` (command prefix= `/user:`)
- projectごとの設定： `<project root>/.claude/commands/` (command prefix= `/project:`

例えば、以下のようなbugfix.mdをglobal設定として使うとします。

`~/.claude/commands/bugfix.md`

```md
\`context7\`
```

一度Command用Markdownファイルを置けば、Claude Codeのスラッシュコマンドとして現れました。

![](https://storage.googleapis.com/zenn-user-upload/4999ee680c43-20250613.png)

今回は `$ARGUMENTS` も設定しているので引数を取ることができます。使い方は以下のような感じです（プロンプトは例で実際は英語でもう少し詳しく書いてます）。

```bash
/user:bugfix Next.jsのHydrationエラーがあるので修正して。
```

これによりClaude Codeは以下のような理解を最初にしてくれました。

![](https://storage.googleapis.com/zenn-user-upload/b38f525fc6be-20250613.png)

画像からわかるように、こちらが設定した実行ステップ1〜3を理解してToDoの準備をしてくれています。

今回のように、Multiple-subagentにMCPサーバーをそれぞれ使ってもらうような指示を構築するために、カスタムスラッシュコマンド化しておくのは有効だと思います。

## まとめ

この記事ではClaude Codeが最新のライブラリ情報を持っていない問題を、MCPサーバー + subagentsを使って解決しようとしました。

今回は検索関係のMCPサーバーをメインで使用しましたが、 **filesystemsや流行りのObsidianのMCPサーバーを使って手持ちのドキュメントをReadさせるのも有効だと思います** 。検索系MCPサーバーもtavilyなどがあるので、そちらも試すといいかもしれません。Claude CodeはまだMCPサーバーを上手く使えている印象ではありませんが、今後MCPサーバーは知っておくべき技術の1つだと思うので色々試せるといいですね。

**Claudeのsubagent並列化は最近研究が盛んな分野** なのでウォッチしておくといいと思います。今回はClaude Code内で簡易的なmultiple-subagentsによる検索を行いましたが、そのうち公式でこの機能がさらに使いやすく提供される気がしています。

この記事が参考になれば幸いです。

## 𝕏フォローしてくれると嬉しいです！

[𝕏でも情報発信しているのでよかったらフォローしてくれると、とても励みになります！！](https://x.com/gaishi_narou)

![](https://storage.googleapis.com/zenn-user-upload/717f1c0df16f-20250613.png)

## 参考文献

169

71

169

71