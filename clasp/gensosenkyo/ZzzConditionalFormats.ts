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
}
