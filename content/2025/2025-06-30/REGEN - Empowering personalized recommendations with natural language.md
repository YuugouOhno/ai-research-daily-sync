---
title: "REGEN: Empowering personalized recommendations with natural language"
source: "https://research.google/blog/regen-empowering-personalized-recommendations-with-natural-language/"
author:
  - "[[Krishna Sayana]]"
  - "[[Hubert Pham]]"
  - "[[Google Research]]"
published: 2025-06-27
created: 2025-06-30
description: "大規模言語モデルを活用した新しいレコメンデーションデータセット「REGEN」を開発し、自然言語対話を通じてより文脈に応じたパーソナライズされた推薦を可能にする。"
tags:
  - "clippings"
---

# REGEN: Empowering personalized recommendations with natural language

## 概要
大規模言語モデル（LLM）を活用した新しいレコメンデーションデータセット「REGEN」を開発。ユーザーとの自然言語対話を通じて、より文脈に応じたパーソナライズされた推薦を可能にする革新的なアプローチを提示。従来のレコメンデーションシステムに対話的機能を追加し、推薦理由の説明生成も可能にした。

## 主要内容

### データセット構築
- Amazon Product Reviews datasetを拡張
- Gemini 1.5 Flashを使用して欠落している会話要素を合成
- 「批評（Critiques）」と「ナラティブ（Narratives）」を追加
- 37万アイテムの大規模データセットを構築

### 実験アプローチ
- FLARE（ハイブリッド）とLUMEN（完全生成）の2つのアーキテクチャを開発
- 推薦とナラティブ生成を統合的に評価
- 異なるドメイン（Office、Clothing）で性能を検証

### 結果と性能
- ユーザーの批評を取り入れることで推薦精度が向上
- リアルタイムでのユーザーフィードバック反映が可能
- 推薦理由の自然言語での説明生成を実現

## 重要なポイント
- 従来のレコメンデーションシステムを自然言語対話へ拡張
- ユーザーフィードバックをリアルタイムで反映
- 推薦理由の説明を生成可能
- 大規模（37万アイテム）データセットでも有効
- FLAREとLUMENという2つの異なるアプローチを比較検証

## 所感・影響
この研究は推薦システムに対話的・人間的な要素を加える重要な進歩を示している。従来の暗黙的なレコメンデーションから、ユーザーとの自然な対話を通じた透明性の高い推薦システムへの転換を可能にする。EC分野における顧客体験の大幅な向上が期待され、AIアシスタントとの統合により更なる発展が見込まれる。