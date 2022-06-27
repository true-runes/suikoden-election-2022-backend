// setValue"s" メソッドの場合には引数は二次元配列になることに注意
namespace ZzzCellOperations {
  export const getRangeSpecificColumnRow2ToRow101 = (columnNumber: number, sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    const startRowNumber = 2
    const endRowNumber = 101

    return sheet.getRange(
      startRowNumber,
      columnNumber,
      endRowNumber - 1, // 自分自身を含めた数になる（何個のセルを埋めるか、ということ）
      1
    )
  }

  // 表示 -> 固定
  export const freezeFirstRow = (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    sheet.setFrozenRows(1)

    return
  }

  export const unFreezeFirstRow = (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    sheet.setFrozenRows(0)

    return
  }

  export const freezeFirstColumn = (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    sheet.setFrozenColumns(1)

    return
  }

  export const unFreezeFirstColumn = (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    sheet.setFrozenColumns(0)

    return
  }

  // 例外的に Apps Script からデータをシートに書き込んでいる（Ruby に寄せるところを）
  // 既存データを上書きする破壊的メソッドなので注意する
  export const setFirstRowNames = (
    sheet: GoogleAppsScript.Spreadsheet.Sheet,
    category = 'mainDivision'
  ) => {
    let names: string[]

    if (category === 'mainDivision') {
      names = ZzzColumnNames.columnNamesOnCountingSheet
    } else if (category === 'bonusVote') {
      names = ZzzColumnNames.columnNamesOnBonusVotesSheet()
    } else if (category === 'directMessage') {
      names = ZzzColumnNames.columnNamesOnDirectMessageSheet
    } else {
      throw new Error('unknown category')
    }

    for (let i = 0 ; i < names.length ; i++) {
      sheet.getRange(1, i + 1).setValue(names[i])
    }
  }

  // カラム名の削除（例外的に Apps Script での対応）
  // 既存データを上書きする破壊的メソッドなので注意する
  export const unSetFirstRowNames = (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    const names = ZzzColumnNames.columnNamesOnCountingSheet

    for (let i = 0 ; i < names.length ; i++) {
      sheet.getRange(1, i + 1).setValue('')
    }
  }

  // 102行目 に '@' を番兵として立たせる（既存データを上書きする破壊的メソッド）
  export const setLastRowSymbols = (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    // 列の末尾は 200列目 (GR) とする
    const range = sheet.getRange(102, 1, 1, 200)

    range.setValue('@')
  }

  // 既存データを上書きする破壊的メソッド
  export const removeLastRowSymbols = (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    const range = sheet.getRange(102, 1, 1, 200)

    range.setValue('')
  }

  // 表示形式 -> ラッピング -> 「折り返す」
  export const rappingOrikaesu = (range: GoogleAppsScript.Spreadsheet.Range) => {
    range.setWrapStrategy(SpreadsheetApp.WrapStrategy.WRAP)
  }

  // 表示形式 -> ラッピング -> 「はみ出す」（デフォルト）
  export const rappingHamidasu = (range: GoogleAppsScript.Spreadsheet.Range) => {
    range.setWrapStrategy(SpreadsheetApp.WrapStrategy.OVERFLOW)
  }

  // 表示形式 -> ラッピング -> 「切り詰める」（はみ出した部分は見えない）
  export const rappingKiritsumeru = (range: GoogleAppsScript.Spreadsheet.Range) => {
    range.setWrapStrategy(SpreadsheetApp.WrapStrategy.CLIP)
  }

  // 挿入 -> チェックボックス（既存データを上書きする破壊的メソッド）
  export const createCheckBoxes = (range: GoogleAppsScript.Spreadsheet.Range) => {
    range.insertCheckboxes();
  }

  // チェックボックスを削除する（既存データを上書きする破壊的メソッド）
  export const removeCheckBoxes = (range: GoogleAppsScript.Spreadsheet.Range) => {
    range.removeCheckboxes();
  }
}
