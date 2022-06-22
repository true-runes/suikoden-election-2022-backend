# まずは何はともあれ公式ドキュメント
- https://github.com/google/clasp/tree/master/docs

# 注意点
- `.ts` のみ push される
  - ただし pull すると `.js` が降ってくる
- コマンドの実行はすべてプロジェクトルートで行う

# 導入

#### 1. $ clasp login して .clasprc.json を生成する
- すでに生成済みの場合は Warning が出る

```bash
$ clasp login
Warning: You seem to already be logged in *globally*. You have a ~/.clasprc.json
Logging in globally…
🔑 Authorize clasp by visiting this url:
https://accounts.google.com/o/oauth2/v2/auth...

Authorization successful.

Default credentials saved to: /home/USERNAME/.clasprc.json.
```

#### 2. シートを指定して clasp clone する
- clone されたファイルはカレント直下に落ちてくる
- 引数を付けない場合は対話形式で対象プロジェクトを選ぶことになる
  - 引数付けた方がいい
- 初回の clone にて、現在の接続プロジェクトに関する情報が書かれた `.clasp.json` が作成される
  - これは `.gitignore` しておく
  - clone 先を変えたい場合は `.clasp.json` を削除して `clone` し直す
- 初回の clone にて、アプリの情報が書かれた `appsscript.json` が生成される
  - 特に弄る必要はない

```bash
$ clasp clone 1Eab-ldf18eQvk2okx6zQfjWkSSGpx25SVe9XXa-7Gj76xhFawW1E52
```

```bash
$ cat .clasp.json
{"scriptId":"1Eab-ldf18eQvk2okx6zQfjWkSSGpx25SVe9XXa-7Gj76xhFawW1E52"","rootDir":"/home/USERNAME/repo"}
```

#### 3. 既存 clone ファイルの拡張子を .ts にする
- 既存ファイルが存在する場合、持ってきたファイルの拡張子は `.js` になっているだろうから、`.ts` に直す
  - `.js` は push の対象外になるので全て `.ts` に直す
  - `.gitignore` にも `.js` を追加しておく

#### 4. tsconfig.json を追加
公式ドキュメントどおりに最低限の `tsconfig.json` を追加する。

```json
{
  "compilerOptions": {
    "lib": ["esnext"],
    "experimentalDecorators": true
  }
}
```

#### 4. 適当なファイルを作成して push してみる
`foo.ts` みたいなファイルを追加する。

```typescript
function myFooFunction() {
  console.log("Hello, MyFooFunction World!");
}
```

そして `$ clasp push` し、Webコンソールにおいて正しく push されているかを確認する。
サブディレクトリで push する際には、カレントディレクトリに空っぽ `{}` の `package.json` を作っておくこと。
