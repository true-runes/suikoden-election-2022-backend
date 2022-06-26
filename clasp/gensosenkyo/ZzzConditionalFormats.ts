// 条件付き書式
// 条件付き書式のカスタム数式の書き方
// https://gyazo.com/eeb783cc8485d174b1775c6234fe744e
// https://bamka.info/docs-google-gyo-irokae/

namespace ZzzConditionalFormats {
  export const setRedBackgroundWhenTrue = (range: GoogleAppsScript.Spreadsheet.Range, sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    ZzzConditionalFormats.setColorToRangeInSpecificCondition(
      range,
      sheet,
      'TRUE',
      '#ffc0cb'
    )
  }

  export const setColorToRangeInSpecificCondition = (range: GoogleAppsScript.Spreadsheet.Range, sheet: GoogleAppsScript.Spreadsheet.Sheet, conditionValue: string, colorCode: string) => {
    const newRule = SpreadsheetApp
      .newConditionalFormatRule()
      .whenTextEqualTo(conditionValue)
      .setBackground(colorCode)
      .setRanges([range])
      .build()

    // 既存のルールに追加する
    const rules = sheet.getConditionalFormatRules()
    rules.push(newRule)

    sheet.setConditionalFormatRules(rules)
  }
}
