---
title: "MCP入門"
source: "https://zenn.dev/mkj/articles/0ed4d02ef3439c"
author:
  - "[[Zenn]]"
published: 2025-04-09
created: 2025-07-01
description: "Model Context Protocol（MCP）の基本概念とアーキテクチャを解説。AIアシスタントが外部データやツールにアクセスするための共通プロトコルについて詳しく説明。"
tags:
  - "selfclip"
  - "clippings"
  - "mcp"
  - "claude-integration"
  - "zenn"
  - "japanese-tech"
  - "japanese-content"
  - "ai-assistant"
---

# MCP入門

## 概要
Model Context Protocol（MCP）は、AIアシスタントがさまざまな外部データやツールにアクセスするための共通のルール（プロトコル）です。従来はAIにデータベースやウェブサービスを使わせる際に個別の接続方法を開発する必要がありましたが、MCPを使うことで接続方式を標準化し、大幅な手間削減と再利用性の向上を実現できます。Anthropicが策定し、OpenAIを含む他社も採用を始めている業界標準として注目されています。

## 主要内容

### MCPの基本概念
MCPは「Host（ホスト）」「Client（クライアント）」「Server（サーバ）」の3つの役割で構成される、AIアシスタント用の標準化プロトコルです。LINEアプリに例えると、ホストがLINEアプリ本体、クライアントが個々のチャットウィンドウやスレッド、サーバが各友達やグループに相当します。

### アーキテクチャの詳細
- **ホスト**: MCP全体の中枢として複数のクライアント（セッション）を生成・管理し、AI（LLM）との連携を指揮
- **クライアント**: 特定のサーバと1対1で通信するセッションを担当し、JSON-RPCでのやり取りを実行
- **サーバ**: AIが活用できる機能やデータを公開し、ツールやリソースを提供

### 通信の仕組み
MCPでは3つの層で通信が実現されます：
1. **プロトコル層（セッション）**: JSON-RPCメッセージの枠組みを定義し、リクエストとレスポンスを結びつけ
2. **トランスポート層**: 実際のバイト列送受信を担当（標準入出力とStreamable HTTPが標準）
3. **メッセージタイプ**: Requests、Results、Errors、Notificationsの4種類でやり取り

### 実装例とコード
記事では最小限のサーバとクライアントの実装例を提供：
- **サーバサイド**: FastMCPを使用した簡単なツール登録とstdio通信
- **クライアントサイド**: ClientSessionを用いた初期化からツール呼び出しまでの流れ

## 重要なポイント
- JSON-RPC 2.0を共通言語として使用し、最初にinitializeメソッドで「名刺交換」を実行
- 一度初期化が完了すれば、tools、resources、prompts、loggingなどを同じルールで処理可能
- サーバはできるだけシンプルに構築し、高い組み合わせ性と段階的な機能追加をサポート
- セキュリティ上、各サーバは自分の権限内で完結し、サーバ同士は直接データを共有しない設計

## 所感・影響
MCPはAIアシスタントの拡張性を飛躍的に向上させる重要なプロトコルです。標準化により開発者の負担が大幅に軽減され、AI機能の組み合わせが容易になることで、より柔軟で強力なAIアプリケーションの開発が可能になります。AnthropicとOpenAIの両社が採用していることから、今後のAI開発における業界標準として確立される可能性が高く、エコシステム全体の発展に大きく寄与すると考えられます。