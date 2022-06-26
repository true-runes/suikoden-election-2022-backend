// 条件付き書式
// 条件付き書式のカスタム数式の書き方
// https://gyazo.com/eeb783cc8485d174b1775c6234fe744e
// https://bamka.info/docs-google-gyo-irokae/

namespace ZzzConditionalFormats {
  export const setRedBackgroundWhenFalse = () => {
    const sheet = ZzzSheetOperations.changeActiveSheetTo('ツイート')
    const range = sheet.getRange(2, 4, 1000, 2) // D2:D1000

    const rule = SpreadsheetApp
      .newConditionalFormatRule()
      .whenTextEqualTo('FALSE')
      .setBackground('#ffc0cb')
      .setRanges([range])
      .build()

    // 既存のルールに追加する
    const rules = sheet.getConditionalFormatRules()
    rules.push(rule)

    sheet.setConditionalFormatRules(rules)
  }
}
