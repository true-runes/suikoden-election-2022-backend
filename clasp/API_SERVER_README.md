# スプレッドシートで API サーバ を立てる際の README

# Tips
- Apps Script 側の appsscript.json が更新されるので、一回取り込んでおくこと
  - そうしないと npx clasp push --watch が対話で止まる

- 更新するときはウェブアプリケーションの「デプロイを管理」から「新バージョン」をリリースする
  - なぜなら、そうしないと URI が変わってしまうから

- 参考記事
  - https://qiita.com/kunichiko/items/7f64c7c80b44b15371a3
  - https://rooter.jp/programming/edit-spreadsheet-with-gas/

# GET の e.parameters
`?foo=bar&hoge=fuga` に対する e.parameters は次の通り。なぜ value が配列なのかはわからんが、params を扱うときには注意する。

```
{
  "foo": ["bar"],
  "hoge": ["fuga"]
}
```

# GET の e.parameter.parameter_name
特定の params を取得した場合には `e.parameter.parameter_name` で素直に取得できる。

# GET で JSON を返すときの定型書式
返す オブジェクト を `returnedObject` とすると、GAS では定型的に以下のように書けば OK である。

```javascript
return ContentService.createTextOutput(JSON.stringify(returnedObject, null, 2)).setMimeType(ContentService.MimeType.JSON)
```

# e.queryString の中身
`exec?foo=bar&hhh=aaaa` のとき `foo=bar&hhh=aaaa` になる。

# POST の際のバリデーションチェック
```javascript
if (e === null || e.postData === null || e.postData.contents === null) {
  return
}
```

# POST の際の POST 内容の オブジェクト への変換
ただし `application/json` で送られてきたとき。

```javascript
// e.postData.contents は予約語である
const postData = JSON.parse(e.postData.contents)
```
