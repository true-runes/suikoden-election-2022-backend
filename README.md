On PostgreSQL Services
[![幻水総選挙2022 バックエンド](https://github.com/true-runes/suikoden-election-2022-backend/actions/workflows/gss2022_backend_on_postgres_services.yml/badge.svg)](https://github.com/true-runes/suikoden-election-2022-backend/actions/workflows/gss2022_backend_on_postgres_services.yml)

On Built-In PostgreSQL
[![幻水総選挙2022 バックエンド](https://github.com/true-runes/suikoden-election-2022-backend/actions/workflows/gss2022_backend_on_built_in_postgres.yml/badge.svg)](https://github.com/true-runes/suikoden-election-2022-backend/actions/workflows/gss2022_backend_on_built_in_postgres.yml)

# 幻水総選挙2022（バックエンド）
- いつもの

# AnalyzeSyntax まわりの流れ
- ツイート or DM を指定して、Natural Language に投げる
  - 受け取った戻り値を JSON化 するなどして analyze_syntaxes に保存する
  - これを cron する
  - 一つの ツイート or DM につき 1つの analyze_syntax が得られる
    - API の戻り値のレコードをまるまる一つに収めたものである
    - 中身は JSON とかあるので掘っていくと個数は多い
      - `sentences` と `tokens` が多い
      - なお `tokens` しか使わない
- PickupCharacterNames.execute(tweet_or_dm_object) によって候補名が配列で得られる
  - 中身は結構複雑
- 中身
  - AnalyzeSyntax#check_words によって、キャラ名データベースと比較するべき単語を配列で得る
    - この際、除外条件を継ぎ足し継ぎ足ししていっている
      - 作りは最低なのでリファクタすべき

# ドキュメント

## Google Natural Language
- https://googleapis.dev/ruby/google-cloud-language/latest/file.MIGRATING.html
- https://googleapis.dev/ruby/google-cloud-language-v1/latest/Google/Cloud/Language/V1/AnalyzeSyntaxResponse.html
- https://cloud.google.com/natural-language/#natural-language-api-demo
