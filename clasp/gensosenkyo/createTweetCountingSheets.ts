const createTweetCountingSheets = () => {
  // const sheetNames = ZzzSheetNames.allSheetNames
  // sheetNames.forEach(sheetName => {
  //   ZzzSheetOperations.removeSheet(sheetName)
  // })
  // createInitialSheets()

  setColumnNames()
  setColumnWidths()
  setBanpeis()
  setProtectedCells()
  createCheckBoxes()
  setRappings()
}

const createInitialSheets = () => {
  const sheetNames = ZzzSheetNames.allSheetNames

  sheetNames.forEach(sheetName => {
    ZzzSheetOperations.createSheet({newSheetName: sheetName})

    // ロールバック（危険）
    // ZzzSheetOperations.removeSheet(sheetName)
  })
}

const setColumnNames = () => {
  // カラムの名前をセルにセットする（本来データは Apps Script 側で入れないが、これは例外）
  // （A列の id を入れるのも Ruby の仕事なので、データ自体は Apps Script では入れない）
  const sheetNames = ZzzSheetNames.allSheetNames

  sheetNames.forEach(sheetName => {
    const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)

    ZzzCellOperations.setFirstRowNames(sheet)

    // 一行目 および 一列目 を固定をする
    ZzzCellOperations.freezeFirstRow(sheet)
    ZzzCellOperations.freezeFirstColumn(sheet)
  })
}

const setColumnWidths = () => {
  const sheetNames = ZzzSheetNames.allSheetNames
  const allColumnNames = ZzzColumnNames.columnNamesOnCountingSheet
  const columNameVsColumnNumber = ZzzSheetOperations.columnNameVsColumnNumber(allColumnNames)

  // 列幅を指定する
  sheetNames.forEach(sheetName => {
    const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)

    sheet.setColumnWidth(columNameVsColumnNumber['ID'], 40); // id 要「切り詰める」
    sheet.setColumnWidth(columNameVsColumnNumber['screen_name'], 30); // screen_name 見えなくていい 要「切り詰める」
    sheet.setColumnWidth(columNameVsColumnNumber['tweet_id'], 30); // tweet_id 見えなくていい 要「切り詰める」
    sheet.setColumnWidth(columNameVsColumnNumber['日時'], 30); // tweeted_at 見えなくていい 要「切り詰める」
    sheet.setColumnWidth(columNameVsColumnNumber['URL'], 30); // url 見えなくていい 要「切り詰める」
    sheet.setColumnWidth(columNameVsColumnNumber['ツイートが見られる？'], 130); // is_visible 要チェックボックス挿入 -> 関連して書式設定
    sheet.setColumnWidth(columNameVsColumnNumber['備考'], 100); // 備考 要折り返し
    sheet.setColumnWidth(columNameVsColumnNumber['要レビュー？'], 90); // 要レビュー？ 要チェックボックス挿入 -> 関連して書式設定
    sheet.setColumnWidth(columNameVsColumnNumber['二次チェック済？'], 130); // 二次チェック済み？ 要チェックボックス挿入 -> 関連して書式設定
    sheet.setColumnWidth(columNameVsColumnNumber['全チェック終了？'], 120); // 全チェック終了？ 要チェックボックス挿入 -> 関連して書式設定
    sheet.setColumnWidth(columNameVsColumnNumber['集計対象外？'], 90); // 集計対象外？ 要チェックボックス挿入 -> 関連して書式設定
    sheet.setColumnWidth(columNameVsColumnNumber['ふぁぼ済？'], 90); // ふぁぼ済み？ 要チェックボックス挿入 -> 関連して書式設定
    sheet.setColumnWidth(columNameVsColumnNumber['別ツイート'], 40); // 別ツイート 見えなくていい
    sheet.setColumnWidth(columNameVsColumnNumber['内容'], 200); // 内容 要折り返し
    sheet.setColumnWidth(columNameVsColumnNumber['キャラ1'], 140); // キャラ1 要データの入力規則
    sheet.setColumnWidth(columNameVsColumnNumber['キャラ2'], 140); // キャラ2 要データの入力規則
    sheet.setColumnWidth(columNameVsColumnNumber['キャラ3'], 140); // キャラ3 要データの入力規則
  })
}

// 既存データを上書きする破壊的メソッドなので注意する
const setBanpeis = () => {
  const sheetNames = ZzzSheetNames.allSheetNames

  // 102行目の各セルに '@' を入れる
  sheetNames.forEach(sheetName => {
    const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)

    ZzzCellOperations.setLastRowSymbols(sheet)
  })
}

const setProtectedCells = () => {
  const sheetNames = ZzzSheetNames.allSheetNames
  const allColumnNames = ZzzColumnNames.columnNamesOnCountingSheet
  const columNameVsColumnNumber = ZzzSheetOperations.columnNameVsColumnNumber(allColumnNames)

  // シートをゆるく保護する
  sheetNames.forEach(sheetName => {
    const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)

    const protectedColumnNumbers = [
      columNameVsColumnNumber['ID'],
      columNameVsColumnNumber['screen_name'],
      columNameVsColumnNumber['tweet_id'],
      columNameVsColumnNumber['日時'],
      columNameVsColumnNumber['URL'],
      columNameVsColumnNumber['全チェック終了？'],
      columNameVsColumnNumber['別ツイート'],
    ]

    protectedColumnNumbers.forEach(protectedColumnNumber => {
      const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(protectedColumnNumber, sheet)

      range.protect() // デフォルトでは自分と自分のグループのみが編集可能（なので大抵はこれでいい）
    })
  })
}

// 既存データを上書きする破壊的メソッドなので注意する
const createCheckBoxes = () => {
  const sheetNames = ZzzSheetNames.allSheetNames
  const allColumnNames = ZzzColumnNames.columnNamesOnCountingSheet
  const columNameVsColumnNumber = ZzzSheetOperations.columnNameVsColumnNumber(allColumnNames)

  // チェックボックスを入れる
  sheetNames.forEach(sheetName => {
    const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)

    // TODO: 対応表を用いて、列の番号はどこでもいいから変数名で指定できるようにする
    const requiredCheckboxColumnNumbers = [
      columNameVsColumnNumber['ツイートが見られる？'],
      columNameVsColumnNumber['全チェック終了？'],
      columNameVsColumnNumber['集計対象外？'],
      columNameVsColumnNumber['ふぁぼ済？'],
      columNameVsColumnNumber['二次チェック済？'],
      columNameVsColumnNumber['要レビュー？'],
    ]

    requiredCheckboxColumnNumbers.forEach(requiredCheckboxColumnNumber => {
      const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(requiredCheckboxColumnNumber, sheet)

      ZzzCellOperations.createCheckBoxes(range)
    })
  })
}

// 表示形式 -> ラッピング -> はみ出す | 折り返す | 切り詰める
const setRappings = () => {
  const sheetNames = ZzzSheetNames.allSheetNames
  const allColumnNames = ZzzColumnNames.columnNamesOnCountingSheet
  const columNameVsColumnNumber = ZzzSheetOperations.columnNameVsColumnNumber(allColumnNames)

  sheetNames.forEach(sheetName => {
    const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)

    const kiritsumeruColumnNumbers = [
      columNameVsColumnNumber['screen_name'],
      columNameVsColumnNumber['tweet_id'],
      columNameVsColumnNumber['日時'],
      columNameVsColumnNumber['URL'],
      columNameVsColumnNumber['別ツイート'],
    ]

    kiritsumeruColumnNumbers.forEach(requiredColumnNumber => {
      const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(requiredColumnNumber, sheet)

      ZzzCellOperations.rappingKiritsumeru(range)
    })

    const orikaesuColumnNumbers = [
      columNameVsColumnNumber['内容'],
      columNameVsColumnNumber['備考'],
    ]

    orikaesuColumnNumbers.forEach(requiredColumnNumber => {
      const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(requiredColumnNumber, sheet)

      ZzzCellOperations.rappingOrikaesu(range)
    })
  })
}
