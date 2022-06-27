const main = () => {
  createTweetCountingSheets.destroyAllSheets()

  // シート作成は 1枚 につき 約15秒 かかる
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

  // 保護設定を全削除（やや重い処理）
  ZzzSheetOperations.removeAllProtectedCellsOnAllSheets()

  // やや重い処理
  // NOTE: 冪等ではない（追記となる）
  ZzzCommonScripts.showStartAndEndLogger(() => {
    createTweetCountingSheets.setProtectedCells()
  }, 'シートの保護機能を適用する')

  // やや重い処理
  ZzzCommonScripts.showStartAndEndLogger(() => {
    createTweetCountingSheets.createCheckBoxes()
  }, 'チェックボックスを作成する')

  ZzzCommonScripts.showStartAndEndLogger(() => {
    createTweetCountingSheets.setRappings()
  }, '「ラッピング」の形式を設定する')

  // 「条件付き書式」を全削除
  ZzzConditionalFormats.clearConditionalFormatsOnAllSheets()

  // NOTE: 冪等ではない（追記となる）
  ZzzCommonScripts.showStartAndEndLogger(() => {
    createTweetCountingSheets.setDefaultConditionalFormats()
  }, '「条件付き書式」を設定する')

  // NOTE: 冪等ではない（追記となる）
  ZzzCommonScripts.showStartAndEndLogger(() => {
    createTweetCountingSheets.setGrayBackGroundInSpecificCondition()
  }, '（条件付き書式）特定のセルが条件を満たしたら行を灰色に塗る')

  // サジェスト用に「入力規則」を設定する（重い）
  console.log('[START] 「入力規則」を設定する（サジェスト用）')
  const sheetNames = ZzzSheetNames.forCountingSheetNames
  const allColumnNames = ZzzColumnNames.columnNamesOnCountingSheet
  const columNameVsColumnNumber = ZzzSheetOperations.correspondenceObjectAboutColumnNameToColumnNumber(allColumnNames)

  sheetNames.forEach(sheetName => {
    ZzzDataValidation.setDataValidationToCell(
      sheetName,
      columNameVsColumnNumber['キャラ1']
    )

    ZzzDataValidation.setDataValidationToCell(
      sheetName,
      columNameVsColumnNumber['キャラ2']
    )

    ZzzDataValidation.setDataValidationToCell(
      sheetName,
      columNameVsColumnNumber['キャラ3']
    )
  })
  console.log('[DONE] 「入力規則」を設定する（サジェスト用）')
}
