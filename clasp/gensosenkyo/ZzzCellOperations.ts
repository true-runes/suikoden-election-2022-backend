namespace ZzzCellsOperations {
  // 表示 -> 固定
  export const freezeFirstRow = (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    sheet.setFrozenRows(1)

    return
  }

  export const unFreezeFirstRow = (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    sheet.setFrozenRows(0)

    return
  }

  // TODO: firstColumn

  // これはデータ投入
  export const setFirstRowNames = (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    const names = ZzzColumnNames.columnNamesOnCountingSheet

    for (let i = 0 ; i < names.length ; i++) {
      sheet.getRange(1, i + 1).setValue(names[i])
    }
  }

  // これはデータ投入（削除）
  export const unSetFirstRowNames = (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    const names = ZzzColumnNames.columnNamesOnCountingSheet

    for (let i = 0 ; i < names.length ; i++) {
      sheet.getRange(1, i + 1).setValue('')
    }
  }

  // 表示形式 -> ラッピング -> 「折り返す」
  export const rappingOrikaesu = (range: GoogleAppsScript.Spreadsheet.Range) => {
    // 「はみ出す」は OVERFLOW で 「切り詰める」は CLIP
    range.setWrapStrategy(SpreadsheetApp.WrapStrategy.WRAP)
  }

  // 挿入 -> チェックボックス
  export const createCheckBoxes = (range: GoogleAppsScript.Spreadsheet.Range) => {
    range.insertCheckboxes();
  }

  // 挿入 -> チェックボックス（削除）
  export const removeCheckBoxes = (range: GoogleAppsScript.Spreadsheet.Range) => {
    range.removeCheckboxes();
  }

  // チェックボックス化する ここから
  // D, F, G H 列
  // ハードコーディングにしたくない
  // const tweetIsVisibleColumnIndex = 4
  // const reviewIsNeededColumnIndex = 6
  // const alreadySecondCheckedIndex = 7
  // const alreadyAllCheckedIndex = 8

  // const targetIndexes = [
  //   tweetIsVisibleColumnIndex,
  //   reviewIsNeededColumnIndex,
  //   alreadySecondCheckedIndex,
  //   alreadyAllCheckedIndex,
  // ]

  // for (let i = 0 ; i < targetIndexes.length ; i++) {
  //   const columnIndex = targetIndexes[i]
  //   // 上限は一千万行らしい
  //   const range = sheet.getRange(2, columnIndex, 100, 1)
  //   ZzzConcerns.createCheckBoxes(range)
  // }
  // チェックボックス化する ここまで
}
