namespace ZzzSheetNames {
  export const allSheetNames = [
    '説明',
    '集計状況',
    '集計_01',
    '集計_02',
    '集計_03',
    '集計_04',
    '集計_05',
    '集計_06',
    '集計_07',
    '集計_08',
    '集計_09',
    '集計_10',
    '集計_11',
    '集計_12',
    '集計_13',
    '集計_14',
    '集計_15',
    '集計_16',
    '集計_17',
    '集計_18',
    '集計_19',
    '集計_20',
    '取得漏れ等'
  ]

  export const forCountingSheetNames = ZzzSheetNames.allSheetNames.filter((sheetName) => {
    return !(['説明', '集計状況'].includes(sheetName))
  })

  export const sheetFilenames: string[] = [
    '投票まとめ',
    '①オールキャラ部門',
    '②協力攻撃部門',
    'DM（ダイレクトメッセージ）',
    'ボーナス票・OP・CLイラスト',
    'ボーナス票・お題小説',
    'ボーナス票・開票イラスト',
    'ボーナス票・推し台詞',
    'ボーナス票・選挙運動',
  ]
}
