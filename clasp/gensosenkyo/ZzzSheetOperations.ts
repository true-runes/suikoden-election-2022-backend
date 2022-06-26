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

    console.log('アクティブ化したいシートが見つかりませんでした')

    return
  }

  // シートの並び順序も保証される
  export const getAllSheetNames = () => {
    const sheetNames = new Array()

    const allSheets = SpreadsheetApp.getActiveSpreadsheet().getSheets();
    for (let i = 0 ; i < allSheets.length ; i++) {
      sheetNames.push(allSheets[i].getName())
    }

    return sheetNames
  }

  // activeSheetName の後ろに sheetName のシートを作成する
  // activeSheetName の指定がない場合は一番最後に作成する
  export const createSheet = ({ activeSheetName = null, newSheetName = '' }) => {
    const allSheetNames = ZzzSheetOperations.getAllSheetNames()
    let sheet: GoogleAppsScript.Spreadsheet.Sheet

    if (activeSheetName === null) {
      sheet = ZzzSheetOperations.changeActiveSheetTo(allSheetNames[allSheetNames.length - 1])
    } else {
      sheet = ZzzSheetOperations.changeActiveSheetTo(activeSheetName)
    }

    const newSheet = SpreadsheetApp.getActiveSpreadsheet().insertSheet()
    newSheet.setName(newSheetName)
  }

  export const removeSheet = (sheetName: string) => {
    var spreadSheet = SpreadsheetApp.getActive();

    const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)
    spreadSheet.deleteSheet(sheet);
  }

  export const columnNameVsColumnNumber = (columnNames: string[]) => {
    let columnNameVsColumnNumber = {}

    columnNames.forEach((columnName, index) => {
      columnNameVsColumnNumber[columnName] = index + 1
    })

    return columnNameVsColumnNumber
  }
}
