namespace ZzzSheetOperations {
  // アクティブシートを変更
  export const changeActiveSheetTo = (sheetName: string) => {
    const allSheets = SpreadsheetApp.getActiveSpreadsheet().getSheets()

    for (let i = 0 ; i < allSheets.length ; i++) {
      if (allSheets[i].getName() === sheetName) {
        SpreadsheetApp.setActiveSheet(allSheets[i])

        return allSheets[i]
      }
    }

    console.log('[LOG] アクティブ化したいシートが見つかりませんでした')

    return
  }

  export const applyFunctionToAllCountingSheets = (fn: any, displayLogText = null) => {
    const sheetNames = ZzzSheetNames.forCountingSheetNames

    ZzzSheetOperations.applyFunctionToSpecificSheetNames(
      fn,
      sheetNames,
      displayLogText
    )

    // 使い方
    // ZzzSheetOperations.applyFunctionToAllCountingSheets(
    //   (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    //     // 全シートに対してやりたいこと
    //   },
    //   'シートごとの実行完了時に表示されるログのテキスト'
    // )
  }

  export const applyFunctionToSpecificSheetNames = (
    fn: any,
    sheetNames: string[],
    displayLogText: string
  ) => {
    sheetNames.forEach(sheetName => {
      const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)

      fn(sheet)

      if (displayLogText) {
        console.log(`[DONE] ${sheetName} : ${displayLogText}`)
      }
    })
  }

  // シートの並び順序も保証される
  export const getAllSheetNames = (): string[] => {
    const sheetNames = new Array()

    const allSheets = SpreadsheetApp.getActiveSpreadsheet().getSheets();
    for (let i = 0 ; i < allSheets.length ; i++) {
      sheetNames.push(allSheets[i].getName())
    }

    return sheetNames
  }

  // activeSheetName の後ろに sheetName のシートを作成する（指定がない場合は一番最後に作成する）
  export const createSheet = ({ activeSheetName = null, newSheetName = '' }) => {
    let sheet: GoogleAppsScript.Spreadsheet.Sheet
    const allSheetNames = ZzzSheetOperations.getAllSheetNames()

    if (allSheetNames.includes(newSheetName)) {
      console.log(`[LOG] ${newSheetName} : すでに存在するシート名です`)
      return
    }

    if (activeSheetName === null) {
      sheet = ZzzSheetOperations.changeActiveSheetTo(allSheetNames[allSheetNames.length - 1])
    } else {
      sheet = ZzzSheetOperations.changeActiveSheetTo(activeSheetName)
    }

    const newSheet = SpreadsheetApp.getActiveSpreadsheet().insertSheet(newSheetName)

    console.log(`[END] ${newSheetName} : シートを作成しました`)
    return newSheet
  }

  // シートの作成および削除については、引数をシートの「名前」にしている
  export const removeSheet = (sheetName: string) => {
    const allSheetNames = ZzzSheetOperations.getAllSheetNames()

    if (!allSheetNames.includes(sheetName)) {
      console.log(`[LOG] ${sheetName} : 存在しないシート名です`)

      return
    }

    const spreadSheet = SpreadsheetApp.getActive();
    const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)
    spreadSheet.deleteSheet(sheet);

    console.log(`[END] ${sheetName} : シートを削除しました`)
    return sheetName
  }

  export const correspondenceObjectAboutColumnNameToColumnNumber = (columnNames: string[]) => {
    let correspondenceObject = {}

    // 「columnNames の配列の並びはカラムの並びになっている」という前提である
    columnNames.forEach((columnName, index) => {
      correspondenceObject[columnName] = index + 1
    })

    return correspondenceObject
  }

  export const removeAllProtectedCellsOnAllSheets = () => {
    ZzzSheetOperations.applyFunctionToAllCountingSheets(
      (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
        ZzzSheetOperations.removeAllProtectedCells(sheet)
      },
      '保護設定の解除'
    )
  }

  export const removeAllProtectedCells = (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    const protectionsRange = sheet.getProtections(SpreadsheetApp.ProtectionType.RANGE);

    for (let i = 0; i < protectionsRange.length; i++) {
      let protection = protectionsRange[i];

      if (protection.canEdit()) {
        protection.remove();
      }
    }
  }

  // ヘッダ行は含まない
  export const setBackgroundColorToSpecificColumnNumberOnSheet = (colNum: number, sheet: GoogleAppsScript.Spreadsheet.Sheet, color: string) => {
    const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(
      colNum,
      sheet
    )

    range.setBackground(color)
  }

  // ヘッダ行は含まない
  export const setValueToSpecificColumnNumberOnSheet = (colNum: number, sheet: GoogleAppsScript.Spreadsheet.Sheet, value: string) => {
    const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(
      colNum,
      sheet
    )

    range.setValue(value)
  }
}
