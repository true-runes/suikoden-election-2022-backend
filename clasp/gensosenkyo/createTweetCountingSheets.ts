const createTweetCountingSheets = () => {
  // シートの作成と破壊
  if (false) {
    if (false) {
      const sheetNames = ZzzSheetNames.allSheetNames
      sheetNames.forEach(sheetName => {
        ZzzSheetOperations.removeSheet(sheetName)
      })
      console.log('シートを削除しました')
    }

    createInitialSheets()
    console.log('シートを作成しました')
  }

  // 列名を入力する
  // setColumnNames()
  console.log('[DONE] setColumnNames')

  // 列幅を調整する
  // setColumnWidths()
  console.log('[DONE] setColumnWidths')

  // 102行目の各セルに '@' を入れる
  // setBanpeis()
  console.log('[DONE] setBanpeis')

  // シートの保護機能を適用する
  // setProtectedCells()
  console.log('[DONE] setProtectedCells')

  // チェックボックスを作成する
  createCheckBoxes()
  console.log('[DONE] createCheckBoxes')

  // 折り返しのタイプを設定する
  // setRappings()
  console.log('[DONE] setRappings')

  // 「条件付き書式」を設定する
  setDefaultConditionalFormats()
  console.log('[DONE] setDefaultConditionalFormats')

  // 実行に凄まじい時間がかかるので別枠でもいい
  // 特定の条件で行全体を灰色にする
  // setGrayBackGroundInSpecificCondition()
  // console.log('[DONE] setGrayBackGroundInSpecificCondition')
}

const createInitialSheets = () => {
  const sheetNames = ZzzSheetNames.allSheetNames

  sheetNames.forEach(sheetName => {
    ZzzSheetOperations.createSheet({newSheetName: sheetName})

    // ロールバック（データ削除が発生し、危険）
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

    sheet.setColumnWidth(columNameVsColumnNumber['ID'], 40)
    sheet.setColumnWidth(columNameVsColumnNumber['screen_name'], 30)
    sheet.setColumnWidth(columNameVsColumnNumber['tweet_id'], 30)
    sheet.setColumnWidth(columNameVsColumnNumber['日時'], 30)
    sheet.setColumnWidth(columNameVsColumnNumber['URL'], 30)
    sheet.setColumnWidth(columNameVsColumnNumber['ツイートが見られない？'], 155)
    sheet.setColumnWidth(columNameVsColumnNumber['備考'], 100)
    sheet.setColumnWidth(columNameVsColumnNumber['要レビュー？'], 90)
    sheet.setColumnWidth(columNameVsColumnNumber['二次チェック済？'], 130)
    sheet.setColumnWidth(columNameVsColumnNumber['全チェック終了？'], 120)
    sheet.setColumnWidth(columNameVsColumnNumber['集計対象外？'], 90)
    sheet.setColumnWidth(columNameVsColumnNumber['ふぁぼ済？'], 90)
    sheet.setColumnWidth(columNameVsColumnNumber['別ツイート'], 40)
    sheet.setColumnWidth(columNameVsColumnNumber['内容'], 200)
    sheet.setColumnWidth(columNameVsColumnNumber['キャラ1'], 140)
    sheet.setColumnWidth(columNameVsColumnNumber['キャラ2'], 140)
    sheet.setColumnWidth(columNameVsColumnNumber['キャラ3'], 140)
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

    const requiredCheckboxColumnNumbers = [
      columNameVsColumnNumber['ツイートが見られない？'],
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

// 長すぎるので「列」ごとにうまく分けたい
const setDefaultConditionalFormats = () => {
// const setDefaultValuesToSpecificColumns = () => {
  const sheetNames = ZzzSheetNames.allSheetNames
  const allColumnNames = ZzzColumnNames.columnNamesOnCountingSheet
  const columNameVsColumnNumber = ZzzSheetOperations.columnNameVsColumnNumber(allColumnNames)

  const requiredReviewColumnNumber = columNameVsColumnNumber['要レビュー？']
  const requiredReviewColumnAlphabet = ZzzConverters.convertColumnNumberToAlphabet(requiredReviewColumnNumber)

  const completedSecondCheckColumnNumber = columNameVsColumnNumber['二次チェック済？']
  const completedSecondCheckAlphabet = ZzzConverters.convertColumnNumberToAlphabet(completedSecondCheckColumnNumber)

  const formula = `=IF(AND(${requiredReviewColumnAlphabet}2=FALSE,${completedSecondCheckAlphabet}2=TRUE),"🌞","☔")`

  // 「全チェック終了？」列
  sheetNames.forEach(sheetName => {
    const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)
    const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(
      columNameVsColumnNumber['全チェック終了？'],
      sheet
    )

    range.setValue(formula) // 初期値を設定する

    ZzzConditionalFormats.setColorToRangeInSpecificCondition(
      range,
      sheet,
      '🌞',
      '#ccffcc' // Green
    )
    ZzzConditionalFormats.setColorToRangeInSpecificCondition(
      range,
      sheet,
      '☔',
      '#ffc0cb' // Red
    )
  })

  // 「要レビュー？」列
  sheetNames.forEach(sheetName => {
    const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)
    const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(
      columNameVsColumnNumber['要レビュー？'],
      sheet
    )

    ZzzConditionalFormats.setColorToRangeInSpecificCondition(
      range,
      sheet,
      'TRUE',
      '#ffc0cb' // Red
    )
  })

  // 「二次チェック済？」列
  sheetNames.forEach(sheetName => {
    const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)
    const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(
      columNameVsColumnNumber['二次チェック済？'],
      sheet
    )

    ZzzConditionalFormats.setColorToRangeInSpecificCondition(
      range,
      sheet,
      'TRUE',
      '#ccffcc' // Red
    )

    ZzzConditionalFormats.setColorToRangeInSpecificCondition(
      range,
      sheet,
      'FALSE',
      '#ffc0cb' // Red
    )
  })

  // 「ふぁぼ済？」列
  sheetNames.forEach(sheetName => {
    const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)
    const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(
      columNameVsColumnNumber['ふぁぼ済？'],
      sheet
    )

    ZzzConditionalFormats.setColorToRangeInSpecificCondition(
      range,
      sheet,
      'TRUE',
      '#ccffcc' // Red
    )

    ZzzConditionalFormats.setColorToRangeInSpecificCondition(
      range,
      sheet,
      'FALSE',
      '#ffc0cb' // Red
    )
  })
}

// 実行に数十分以上かかる
const setGrayBackGroundInSpecificCondition = () => {
  const sheetNames = ZzzSheetNames.allSheetNames
  const allColumnNames = ZzzColumnNames.columnNamesOnCountingSheet
  const columNameVsColumnNumber = ZzzSheetOperations.columnNameVsColumnNumber(allColumnNames)

  let columnAlphabet: string

  sheetNames.forEach(sheetName => {
    const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)

    for (let i = 2; i <= 101; i++) {
      columnAlphabet = ZzzConverters.convertColumnNumberToAlphabet(columNameVsColumnNumber['集計対象外？'])

      ZzzConditionalFormats.setGrayBackgroundToAllRowCellsInSpecificCondition(
        i,
        sheet,
        `=$${columnAlphabet}$${i}=TRUE`
      )

      columnAlphabet = ZzzConverters.convertColumnNumberToAlphabet(columNameVsColumnNumber['ツイートが見られない？'])

      ZzzConditionalFormats.setGrayBackgroundToAllRowCellsInSpecificCondition(
        i,
        sheet,
        `=$${columnAlphabet}$${i}=TRUE`
      )
    }
  })
}
