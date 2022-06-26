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

  export const applyFunctionToAllCountingSheets = (fn: any) => {
    const sheetNames = ZzzSheetNames.forCountingSheetNames

    ZzzSheetOperations.applyFunctionToSpecificSheetNames(
      fn,
      sheetNames
    )

    // 使い方
    // ZzzSheetOperations.applyFunctionToAllCountingSheets(
    //   (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
    //     SpreadsheetApp.getActive().deleteSheet(sheet)
    //   }
    // )
  }

  export const applyFunctionToSpecificSheetNames = (fn: any, sheetNames: string[]) => {
    sheetNames.forEach(sheetName => {
      const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)

      fn(sheet)

      console.log(`[END] ${sheetName} : ZzzSheetOperations.applyFunctionToSheet`)
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

    const newSheet = SpreadsheetApp.getActiveSpreadsheet().insertSheet()
    newSheet.setName(newSheetName)

    console.log(`[END] ${newSheetName} : ZzzSheetOperations.createSheet`)
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

    console.log(`'[END] ${sheetName} : ZzzSheetOperations.removeSheet`)
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
}
