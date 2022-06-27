// 「入力規則」
namespace ZzzDataValidation {
  export const setDataValidationToCell = (sheet: GoogleAppsScript.Spreadsheet.Sheet, columnNumber: number, destroyWord: string = '') => {
    const startRowNumber = 2
    const endRowNumber = 101

    for (let i = startRowNumber ; i <= endRowNumber ; i++) {
      const dataValidationTargetCell = sheet.getRange(i, columnNumber, 1, 1)

      if (destroyWord === 'DESTROY') { // この引数が与えられていると入力規則全削除
        dataValidationTargetCell.setDataValidation(null)
      } else {
        const pullDownValuesRange = ZzzDataValidation.rangeWhichContainsDataList(i, sheet)
        const rule = SpreadsheetApp.newDataValidation().requireValueInRange(pullDownValuesRange).build()

        dataValidationTargetCell.setDataValidation(rule)
      }
    }
  }

  export const rangeWhichContainsDataList = (rowNumber: number, sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    // AXn (50列目) を始点として、GRn (200列目)までの列で、行は n行目 である範囲
    // 第3引数 および 第4引数 には注意が必要で、自分自身を含めた個数を指定する
    // したがって 第4引数 の値は 151 になる
    // cf. https://takamin.github.io/techtips/xlsColNumMap

    return sheet.getRange(rowNumber, 50, 1, 151)
  }

  export const setDataValidationDirectMessageTypes = (sheet: GoogleAppsScript.Spreadsheet.Sheet, columnNumber: number, destroyWord: string = '') => {
    const startRowNumber = 2
    const endRowNumber = 101

    for (let i = startRowNumber ; i <= endRowNumber ; i++) {
      const dataValidationTargetCell = sheet.getRange(i, columnNumber, 1, 1)

      if (destroyWord === 'DESTROY') { // この引数が与えられていると入力規則全削除
        dataValidationTargetCell.setDataValidation(null)
      } else {
        const requiredValues = ZzzDataValidation.directMessageTypes
        const rule = SpreadsheetApp.newDataValidation().requireValueInList(requiredValues).build()

        dataValidationTargetCell.setDataValidation(rule)
      }
    }
  }

  export const directMessageTypes = [
    '①オールキャラ部門',
    '②協力攻撃部門',
    'ボ・OP・CLイラスト',
    'ボ・お題小説',
    'ボ・開票イラスト',
    'ボ・推し台詞',
    'ボ・選挙運動',
    '票に関係ない',
  ]
}
