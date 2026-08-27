# TuistProjectMaker

[English](README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [简体中文](README.zh-Hans.md)

Tuist ベースの iOS プロジェクトを Clean Architecture 構成でスキャフォールドする macOS GUI ツール。

## 構成

`TuistProjectMaker/` — SwiftUI で作られた macOS アプリ（Swift Package）。

ステップ形式のウィザードでプロジェクトを作成する:

1. 作成場所を選択
2. プロジェクト名を入力
3. プロジェクト設定（組織名、Bundle ID プレフィックス、最小デプロイターゲット）
4. 環境チェック（`tuist` CLI のインストール状況、未インストールならワンクリックでインストール）
5. Domain 構成（Entity / UseCase / Repository Interface、名前で追加・削除）
6. Data 構成（Repository 実装 / DTO / DataSource、名前で追加・削除）
7. Presentation 構成（画面、名前で追加・削除）
8. UI フレームワーク選択（SwiftUI / UIKit）
9. Presentation パターン選択（MVVM / MVVM-C / TCA — TCA は SwiftUI のみ）
10. 確認画面で完了を押すとプロジェクトを生成し、Finder で表示する

レイヤーをまたいで同名の要素（例: `User` DataSource と `User` RepositoryImpl）はコンストラクタ注入で自動的に接続され、生成された `DIContainer` に組み立てられる。

アプリの UI は英語・韓国語・日本語・簡体字中国語に対応しており、システム言語に従う。

## 実行

```sh
cd TuistProjectMaker
swift run
```

ダブルクリックで起動できる `.app` バンドルとしてパッケージ化するには:

```sh
cd TuistProjectMaker
./package_app.sh
open .build/TuistProjectMaker.app
```
