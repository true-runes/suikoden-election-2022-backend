const main = () => {
  createTweetCountingSheets.createAllSheets()

  ZzzCommonScripts.showStartAndEndLogger(() => {
    createTweetCountingSheets.setColumnNames()
  }, '列名を入力する')

  ZzzCommonScripts.showStartAndEndLogger(() => {
    createTweetCountingSheets.freezeFirstRowAndFirstColumn()
  }, '一行目 および 一列目 を固定をする')

  ZzzCommonScripts.showStartAndEndLogger(() => {
    createTweetCountingSheets.setColumnWidths()
  }, '列幅を調整する')

  ZzzCommonScripts.showStartAndEndLogger(() => {
    createTweetCountingSheets.setBanpeis()
  }, '102行目の各セルに "@" を入れる')

  // シートの保護機能を適用する（重め）
  ZzzCommonScripts.showStartAndEndLogger(() => {
    createTweetCountingSheets.setProtectedCells()
  }, 'シートの保護機能を適用する')

  // チェックボックスを作成する（重め）
  ZzzCommonScripts.showStartAndEndLogger(() => {
    createTweetCountingSheets.createCheckBoxes()
  }, 'チェックボックスを作成する')

  // 「ラッピング」の形式を設定する
  ZzzCommonScripts.showStartAndEndLogger(() => {
    createTweetCountingSheets.setRappings()
  }, '「ラッピング」の形式を設定する')

  // // 「条件付き書式」を設定する
  // console.log('[START] 「条件付き書式」を設定する')
  // // FIXME: ここが重い（3分ぐらいかかる）
  // createTweetCountingSheets.setDefaultConditionalFormats()
  // console.log('[DONE] 「条件付き書式」を設定する')

  // // （条件付き書式）特定のセルが条件を満たしたら行を灰色に塗る
  // console.log('[START] （条件付き書式）特定のセルが条件を満たしたら行を灰色に塗る')
  // createTweetCountingSheets.setGrayBackGroundInSpecificCondition()
  // console.log('[DONE] （条件付き書式）特定のセルが条件を満たしたら行を灰色に塗る')

  // // FIXME: ここが重い（3分ぐらいかかる）
  // console.log('[START] 「入力規則」を設定する（サジェスト用）')
  // // 「入力規則」を設定する（サジェスト用）
  // const sheetNames = ZzzSheetNames.forCountingSheetNames
  // const allColumnNames = ZzzColumnNames.columnNamesOnCountingSheet
  // const columNameVsColumnNumber = ZzzSheetOperations.correspondenceObjectAboutColumnNameToColumnNumber(allColumnNames)

  // sheetNames.forEach(sheetName => {
  //   ZzzDataValidation.setDataValidationToCell(
  //     sheetName,
  //     columNameVsColumnNumber['キャラ1']
  //   )

  //   ZzzDataValidation.setDataValidationToCell(
  //     sheetName,
  //     columNameVsColumnNumber['キャラ2']
  //   )

  //   ZzzDataValidation.setDataValidationToCell(
  //     sheetName,
  //     columNameVsColumnNumber['キャラ3']
  //   )
  // })
  // console.log('[DONE] 「入力規則」を設定する（サジェスト用）')
}
