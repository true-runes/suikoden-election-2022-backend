// TODO: 列名は Ruby 側と共有したい
namespace ZzzColumnNames {
  export const columnNamesOnCountingSheet: string[] = [
    'id', // 自動、UNIQUE
    'screen_name', // @いらない
    'tweet_id', // 自動、UNIQUE、文字列にしないと E+18 になる
    '日時', // 自動
    'URL', // 自動、UNIQUE
    'ツイートが見られる？', // 自動
    '備考', // 人が入力する
    '要レビュー？', // 人が入力する
    '二次チェック済み？', // 人が入力する
    '全チェック終了？', // 自動
    '集計対象外？',  // 人が入力する、TRUE なら灰色化
    'ふぁぼ済み？',  // 人が入力する、TRUE なら灰色化
    // ここから下が重要
    '他ツイートID', // 自動、ids をカンマ区切りで（多重、複数ツイート）
    '内容', // 自動
    'キャラ1', // 人が入力する
    'キャラ2', // 人が入力する
    'キャラ3', // 人が入力する
  ]

  export const columnNamesOnBonusVotesSheet = (): string[] => {
    const columnNamesOnCountingSheet = ZzzColumnNames.columnNamesOnCountingSheet

    return columnNamesOnCountingSheet.concat([
      'キャラ4', // 人が入力する
      'キャラ5', // 人が入力する
      'キャラ6', // 人が入力する
      'キャラ7', // 人が入力する
      'キャラ8', // 人が入力する
      'キャラ9', // 人が入力する
      'キャラ10', // 人が入力する
    ])
  }

  // id（自動）	送信者（自動）	内容（自動）	キャラ1	キャラ2	キャラ3
  // ツイートが見られる？（自動）	備考	要レビュー？	返信 or チェック済み？
  // 全チェック終了？
  export const columnNamesOnDirectMessageSheet: string[] = [
    'id', // UNIQUE
    'screen_name', // @いらない
    'dm_id',  // 自動 dm.id_number
    'messaged_at',  // 自動 dm.messaged_at
    'DMが見られる？（自動）', // 自動
    '備考', // 人が入力する
    '要レビュー？', // 人が入力する
    '二次チェック済み？', // 人が入力する
    '全チェック終了？', // 自動
    '集計対象外？', // 人が入力する、TRUE なら灰色化
    // 'ふぁぼ済み？',
    // ここから下が重要
    '内容（自動）', // dm.content_text (text)
    'division', // オールキャラ or 協力攻撃 or その他（あとから作ってもいい）
    'suggest_unite_attack', // 人が入力する
    'suggest_all_characters_01', // 人が入力する
    'suggest_all_characters_02', // 人が入力する
    'suggest_all_characters_03', // 人が入力する
  ]
}
