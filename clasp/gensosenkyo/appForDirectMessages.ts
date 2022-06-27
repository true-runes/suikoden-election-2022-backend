const mainForDirectMessages = () => {
  // createTweetCountingSheets.destroyAllSheets()

  // NOTE: 約6分かかる
  createTweetCountingSheets.createAllSheets()

  ZzzCommonScripts.showStartAndEndLogger(() => {
    createTweetCountingSheets.setColumnNames('directMessage')
  }, '列名を入力する')

  ZzzCommonScripts.showStartAndEndLogger(() => {
    createTweetCountingSheets.freezeFirstRowAndFirstColumn()
  }, '一行目 および 一列目 を固定をする')

  ZzzCommonScripts.showStartAndEndLogger(() => {
    createTweetCountingSheets.setColumnWidths('directMessage')
  }, '列幅を調整する')

  ZzzCommonScripts.showStartAndEndLogger(() => {
    createTweetCountingSheets.setBanpeis()
  }, '102行目の各セルに "@" を入れる')

  // 保護設定を全削除（やや重い処理）
  ZzzSheetOperations.removeAllProtectedCellsOnAllSheets()

  // やや重い処理
  ZzzCommonScripts.showStartAndEndLogger(() => {
    createTweetCountingSheets.createCheckBoxes('directMessage')
  }, 'チェックボックスを作成する')

  ZzzCommonScripts.showStartAndEndLogger(() => {
    createTweetCountingSheets.setRappings('directMessage')
  }, '「ラッピング」の形式を設定する')

  // 「条件付き書式」を全削除
  ZzzConditionalFormats.clearConditionalFormatsOnAllSheets()

  // NOTE: 冪等ではない（追記となる）
  ZzzCommonScripts.showStartAndEndLogger(() => {
    // FIXME: 列がズレている
    createTweetCountingSheets.setDefaultConditionalFormats('directMessage')
  }, '「条件付き書式」を設定する')

  // NOTE: 冪等ではない（追記となる）
  ZzzCommonScripts.showStartAndEndLogger(() => {
    createTweetCountingSheets.setGrayBackGroundInSpecificCondition('directMessage')
  }, '（条件付き書式）特定のセルが条件を満たしたら行を灰色に塗る')

  // サジェスト用に「入力規則」を設定する（重い）
  createTweetCountingSheets.setDataValidationsForSuggestions('directMessage')

  // 「種類」に「入力規則」を与える
  const colNameToNumber = ZzzColumnNames.colNameToNumber('directMessage')

  ZzzSheetOperations.applyFunctionToAllCountingSheets(
    (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
      ZzzDataValidation.setDataValidationDirectMessageTypes(
        sheet,
        colNameToNumber['種類']
      )
    },
    '「種類」の「入力規則」を設定する'
  )
}
