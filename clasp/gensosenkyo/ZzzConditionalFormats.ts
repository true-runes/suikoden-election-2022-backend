// 条件付き書式
namespace ZzzConditionalFormats {
  export const setColorToRangeInSpecificCondition = (
    range: GoogleAppsScript.Spreadsheet.Range,
    sheet: GoogleAppsScript.Spreadsheet.Sheet,
    conditionValue: string,
    colorCode: string
  ) => {
    const newRule = SpreadsheetApp
      .newConditionalFormatRule()
      .whenTextEqualTo(conditionValue) // この条件が満たされる時に（セル無指定の場合は条件が判定されるセルは range に等しい）、
      .setBackground(colorCode) // このメソッドが適用されて、
      .setRanges([range]) // 適用範囲は range になる（getRange した値を配列にくるんで渡す）
      .build()

    // 既存のルールに追加する
    const rules = sheet.getConditionalFormatRules()
    rules.push(newRule)

    sheet.setConditionalFormatRules(rules)
  }

  // 「カスタム数式」における、判定対象セルと適用される範囲の関係は分かりづらいので、以下などを参照
  // https://bamka.info/docs-google-gyo-irokae/
  export const getRuleToSetGrayBackgroundToAllRowCellsInSpecificCondition  = (
    rowNumber: number,
    sheet: GoogleAppsScript.Spreadsheet.Sheet,
    formulaSatisfied: string,
    range: GoogleAppsScript.Spreadsheet.Range
  ) => {
    // formulaSatisfied は '=$F$2=FALSE' などのような形の条件文になる
    const newRule = SpreadsheetApp
      .newConditionalFormatRule()
      .whenFormulaSatisfied(formulaSatisfied) // この条件が満たされる時に、
      .setBackground('#a9a9a9') // このメソッドが適用されて、
      // .setRanges([sheet.getRange(rowNumber, 1, 1, 50)]) // 適用範囲は range になる（getRange した値を配列にくるんで渡す）
      .setRanges([range]) // 適用範囲は range になる（getRange した値を配列にくるんで渡す）
      .build()

    return newRule
  }

  export const clearConditionalFormatsOnAllSheets = () => {
    ZzzSheetOperations.applyFunctionToAllCountingSheets((sheet) => {
      sheet.clearConditionalFormatRules();
    }, '「条件付き書式」をクリアしました')
  }

  export const setInitToIsAllCompletedColumn = (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    const colNameToNumber = ZzzColumnNames.colNameToNumber()

    const requiredReviewColumnNumber = colNameToNumber['要レビュー？']
    const requiredReviewColumnAlphabet = ZzzConverters.convertColumnNumberToAlphabet(requiredReviewColumnNumber)

    const completedSecondCheckColumnNumber = colNameToNumber['二次チェック済？']
    const completedSecondCheckAlphabet = ZzzConverters.convertColumnNumberToAlphabet(completedSecondCheckColumnNumber)

    const formula = `=IF(AND(${requiredReviewColumnAlphabet}2=FALSE,${completedSecondCheckAlphabet}2=TRUE),"🌞","☔")`

    // 「全終了？」列
    const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(
      colNameToNumber['全終了？'],
      sheet
    )

    // '☔' という初期値を設定する
    range.setValue(formula)
    range.setHorizontalAlignment('center');

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
  }

  export const setInitToIsRequiredReview = (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    const colNameToNumber = ZzzColumnNames.colNameToNumber()

    const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(
      colNameToNumber['要レビュー？'],
      sheet
    )
    ZzzConditionalFormats.setColorToRangeInSpecificCondition(
      range,
      sheet,
      'TRUE',
      '#ffc0cb' // Red
    )
  }

  export const setInitToIsCompletedSecondCheck = (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    const colNameToNumber = ZzzColumnNames.colNameToNumber()

    const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(
      colNameToNumber['二次チェック済？'],
      sheet
    )
    ZzzConditionalFormats.setColorToRangeInSpecificCondition(
      range,
      sheet,
      'TRUE',
      '#ccffcc' // Green
    )
    ZzzConditionalFormats.setColorToRangeInSpecificCondition(
      range,
      sheet,
      'FALSE',
      '#ffc0cb' // Red
    )
  }

  export const setInitToIsCompletedFavorite = (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    const colNameToNumber = ZzzColumnNames.colNameToNumber()

    const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(
      colNameToNumber['ふぁぼ済？'],
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
  }
}
