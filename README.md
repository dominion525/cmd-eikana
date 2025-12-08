# ⌘英かな (cmd-eikana) - Apple Silicon Fork

![Build](https://github.com/dominion525/cmd-eikana/actions/workflows/build.yml/badge.svg)
![License](https://img.shields.io/github/license/dominion525/cmd-eikana)
![Platform](https://img.shields.io/badge/platform-macOS%2012.0%2B-blue)

This is a fork of [iMasanari/cmd-eikana](https://github.com/iMasanari/cmd-eikana) for Apple Silicon Macs.

左右のコマンドキーを単体で押した時に英数/かなを切り替えるアプリです。
設定をいじることでキーリマップアプリとしても利用できます。

## Fork版について

このリポジトリは [iMasanari](https://github.com/iMasanari) 氏による [オリジナル版](https://github.com/iMasanari/cmd-eikana) のフォークです。

### オリジナル版との違い
- Apple Silicon (arm64) 専用ビルド
- 最小動作要件: macOS 12.0 (Monterey) 以降
- Bundle ID: `io.github.dominion525.cmd-eikana`

## ダウンロード

[GitHub Releases](https://github.com/dominion525/cmd-eikana/releases) からダウンロードしてください。

## 使い方（初回起動時）

### 1. アプリを開く

本アプリは未署名のため、macOSのGatekeeperによってブロックされます。以下の手順で開いてください：

1. ⌘英かな.appを**右クリック**（またはControl+クリック）
2. メニューから「開く」を選択
3. 警告ダイアログが表示されたら「開く」をクリック

**右クリックでも開けない場合：**
1. システム設定 →「プライバシーとセキュリティ」を開く
2. 下にスクロールすると「"⌘英かな"は開発元を確認できないため...」のメッセージが表示されています
3. 「このまま開く」ボタンをクリック

### 2. アクセシビリティの許可

アクセシビリティ機能へのアクセスの確認ダイアログが表示されるので「"システム設定"を開く」をクリックします。
プライバシーとセキュリティ > アクセシビリティ で⌘英かな.appにチェックを入れてください。

## オリジナル版からの移行

オリジナル版（iMasanari/cmd-eikana）から移行する場合、Bundle IDが異なるためアクセシビリティの設定が競合することがあります。

1. オリジナル版の⌘英かなを終了
2. システム設定 →「プライバシーとセキュリティ」→「アクセシビリティ」を開く
3. 古い⌘英かなのエントリを削除（-ボタン）
4. 本フォーク版を起動し、新しくアクセシビリティを許可

## 終了方法

右上のステータスバーにある「⌘」アイコンを開き、「Quit」を選びます。

## アンインストール方法

⌘英かな.appをゴミ箱に入れてください。
また、設定ファイルが`~/Library/Preferences/io.github.dominion525.cmd-eikana.plist`にあります。
綺麗さっぱり消したいという場合はこちらもゴミ箱に入れてください。

## 動作確認環境

- macOS 15.7 Sequoia (Apple Silicon)

## ビルド方法

```bash
xcodebuild -project "⌘英かな.xcodeproj" -scheme "⌘英かな" \
  -configuration Release -arch arm64 clean build
```

## Credits

- Original Author: [iMasanari](https://github.com/iMasanari)
- Fork Maintainer: [dominion525](https://github.com/dominion525)

## ライセンス

MIT License - Copyright (c) 2016 iMasanari
