namespace ZzzColumnNames {
  // ここの命名は変更することがしばしばあり得るから、固定した英数命名に紐づけたい
  export const columnNamesOnCountingSheet: string[] = [
    'ID',
    'screen_name',
    'tweet_id',
    '日時',
    'URL',
    '別ツイ',
    '全終了？',
    'ツイ見られない？',
    '集計対象外？',
    'ふぁぼ済？', // OnCounting では不要だが、冪等性維持のため含んでいる
    '二次チェック済？',
    '内容',
    '備考',
    '要レビュー？',
    'キャラ1 or 作品名', // 協力攻撃の場合は「作品名」
    'キャラ2 or 協力攻撃名', // 協力攻撃の場合は「協力攻撃名」
    'キャラ3', // 協力攻撃の場合は空文字
  ]

  export const columnNamesOnBonusVotesSheet = (): string[] => {
    const columnNamesOnCountingSheet = ZzzColumnNames.columnNamesOnCountingSheet

    return columnNamesOnCountingSheet.concat([
      'キャラ4',
      'キャラ5',
      'キャラ6',
      'キャラ7',
      'キャラ8',
      'キャラ9',
      'キャラ10',
    ])
  }

  export const columnNamesOnDirectMessageSheet: string[] = [
    'ID',
    'screen_name',
    'dm_id',
    '日時',
    'DMが見られない？',
    '備考',
    '要レビュー？',
    '二次チェック済み？',
    '対応済み？',
    '全終了？',
    '集計対象外？',
    '内容',
    '種類',
    'キャラ1 or 作品名',
    'キャラ2 or 協力攻撃名',
    'キャラ3',
    'キャラ4', // 「種類」に総選挙運動が来た場合などを考えるとキャラ数は不定になる
    'キャラ5',
    'キャラ6',
    'キャラ7',
    'キャラ8',
    'キャラ9',
    'キャラ10',
  ]

  export const colNameToNumber = () => {
    return ZzzSheetOperations
      .correspondenceObjectAboutColumnNameToColumnNumber(
        ZzzColumnNames.columnNamesOnCountingSheet
      )
    }
}
