---
layout: default
---

<div style="display: flex; align-items: center; gap: 16px;">
  <img src="icon.png" width="64" height="64" alt="⌘英かな">
  <h1 style="margin: 0;">⌘英かな - Apple Silicon版</h1>
</div>

macOSで左右のコマンドキーを単体で押したときに英数/かなを切り替えるユーティリティです。USキーボードでもJISキーボードの「英数」「かな」キーと同様の操作感を実現できます。

本アプリケーションは [iMasanari/cmd-eikana](https://github.com/iMasanari/cmd-eikana) をApple Silicon向けにフォークしたものです。オリジナル版の詳細な説明は[公式サイト](https://ei-kana.appspot.com/)をご覧ください。

---

## ダウンロード

<div style="text-align: center; margin: 2em 0;">
  <a href="https://github.com/dominion525/cmd-eikana/releases/latest" style="display: inline-flex; align-items: center; background: #4a90d9; color: white; text-decoration: none; padding: 12px 24px; border-radius: 8px; font-size: 1.1em;">
    Download ⌘英かな-v2.3.0
    <span style="background: #666; color: white; padding: 4px 10px; border-radius: 4px; margin-left: 12px; font-size: 0.85em;">macOS 12.0+ / Apple Silicon</span>
  </a>
  <div style="margin-top: 1em;">
    <a href="https://github.com/dominion525/cmd-eikana">View project on GitHub</a>
  </div>
</div>

---

## キーバインド

| 入力 | 出力 | 備考 |
|:-----|:-----|:-----|
| 左⌘（単押し） | 英数 | 他のキーと組み合わせない場合 |
| 右⌘（単押し） | かな | 他のキーと組み合わせない場合 |
| ⌘ + 他のキー | 通常動作 | ショートカットとして機能 |

コマンドキーを単独で押して離したときに入力切り替えが発動します。⌘+C や ⌘+V などのショートカットは通常通り使用できます。

---

## 初回起動時の設定

本アプリは未署名のため、macOSのGatekeeperによってブロックされます。以下の手順で開いてください。

### 1. アプリを開く

⌘英かな.appをダブルクリックすると、以下のダイアログが表示されます。

![ブロックダイアログ](setup-00-blocked.png)

ここでは「**完了**」をクリックしてください。

### 2. システム設定から許可する

システム設定を開き、「**プライバシーとセキュリティ**」を選択します。

![プライバシーとセキュリティ](setup-01-privacy-security.png)

下にスクロールすると、「"⌘英かな"がブロックされました」というメッセージが表示されています。「**このまま開く**」ボタンをクリックしてください。

![このまま開く](setup-02-allow-app.png)

### 3. 確認ダイアログ

「⌘英かなを開きますか？」というダイアログが表示されます。「**このまま開く**」をクリックしてください。

![開きますか？ダイアログ](setup-03-open-dialog.png)

### 4. 認証

Touch IDまたはパスワードで認証を求められます。認証してください。

![認証ダイアログ](setup-04-auth.png)

### 5. アクセシビリティの許可

アプリが起動すると、アクセシビリティの許可を求められます。システム設定の「プライバシーとセキュリティ」→「アクセシビリティ」で⌘英かなを許可してください。

---

## オリジナル版からの移行

オリジナル版（iMasanari/cmd-eikana）から移行する場合、Bundle IDが異なるためアクセシビリティの設定が競合することがあります。

1. オリジナル版の⌘英かなを終了
2. システム設定 →「プライバシーとセキュリティ」→「アクセシビリティ」を開く
3. 古い⌘英かなのエントリを削除（-ボタン）
4. 本フォーク版を起動し、新しくアクセシビリティを許可

---

## 終了方法

右上のステータスバーにある「⌘」アイコンをクリックし、「Quit」を選びます。

## アンインストール

⌘英かな.appをゴミ箱に入れてください。設定ファイル `~/Library/Preferences/io.github.dominion525.cmd-eikana.plist` も削除すると完全にアンインストールできます。

---

## クレジット

- オリジナル版: [iMasanari/cmd-eikana](https://github.com/iMasanari/cmd-eikana)
- オリジナル公式サイト: [https://ei-kana.appspot.com/](https://ei-kana.appspot.com/)

## ライセンス

MIT License
