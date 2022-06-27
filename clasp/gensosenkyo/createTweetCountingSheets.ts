namespace createTweetCountingSheets {
  export const createAllSheets = () => {
    const sheetNames = ZzzSheetNames.allSheetNames

    // とてもコストが高い実行内容
    sheetNames.forEach(sheetName => {
      ZzzSheetOperations.createSheet({newSheetName: sheetName})
    })

    return sheetNames
  }

  export const destroyAllSheets = () => {
    const sheetNames = ZzzSheetNames.allSheetNames

    sheetNames.forEach(removeSheet => {
      ZzzSheetOperations.removeSheet(removeSheet)
    })

    return sheetNames
  }

  export const setColumnNames = () => {
    const sheetNames = ZzzSheetNames.forCountingSheetNames

    sheetNames.forEach(sheetName => {
      const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)

      ZzzCellOperations.setFirstRowNames(sheet)
    })
  }

  export const freezeFirstRowAndFirstColumn = () => {
    ZzzSheetOperations.applyFunctionToAllCountingSheets(
      (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
        ZzzCellOperations.freezeFirstRow(sheet)
        ZzzCellOperations.freezeFirstColumn(sheet)
      }, '一行目 および 一列目 を固定をする'
    )
  }

  export const setColumnWidths = () => {
    const sheetNames = ZzzSheetNames.forCountingSheetNames
    const allColumnNames = ZzzColumnNames.columnNamesOnCountingSheet
    const columNameVsColumnNumber = ZzzSheetOperations.correspondenceObjectAboutColumnNameToColumnNumber(allColumnNames)

    // 列幅を指定する
    sheetNames.forEach(sheetName => {
      const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)

      sheet.setColumnWidth(columNameVsColumnNumber['ID'], 40)
      sheet.setColumnWidth(columNameVsColumnNumber['screen_name'], 30)
      sheet.setColumnWidth(columNameVsColumnNumber['tweet_id'], 30)
      sheet.setColumnWidth(columNameVsColumnNumber['日時'], 30)
      sheet.setColumnWidth(columNameVsColumnNumber['URL'], 30)
      sheet.setColumnWidth(columNameVsColumnNumber['ツイートが見られない？'], 155)
      sheet.setColumnWidth(columNameVsColumnNumber['備考'], 100)
      sheet.setColumnWidth(columNameVsColumnNumber['要レビュー？'], 90)
      sheet.setColumnWidth(columNameVsColumnNumber['二次チェック済？'], 130)
      sheet.setColumnWidth(columNameVsColumnNumber['全チェック終了？'], 120)
      sheet.setColumnWidth(columNameVsColumnNumber['集計対象外？'], 90)
      sheet.setColumnWidth(columNameVsColumnNumber['ふぁぼ済？'], 90)
      sheet.setColumnWidth(columNameVsColumnNumber['別ツイート'], 40)
      sheet.setColumnWidth(columNameVsColumnNumber['内容'], 200)
      sheet.setColumnWidth(columNameVsColumnNumber['キャラ1'], 140)
      sheet.setColumnWidth(columNameVsColumnNumber['キャラ2'], 140)
      sheet.setColumnWidth(columNameVsColumnNumber['キャラ3'], 140)
    })
  }

  // 既存データを上書きする破壊的メソッドなので注意する
  export const setBanpeis = () => {
    const sheetNames = ZzzSheetNames.forCountingSheetNames

    // 102行目の各セルに '@' を入れる
    sheetNames.forEach(sheetName => {
      const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)

      ZzzCellOperations.setLastRowSymbols(sheet)
    })
  }

  export const setProtectedCells = () => {
    const sheetNames = ZzzSheetNames.forCountingSheetNames
    const allColumnNames = ZzzColumnNames.columnNamesOnCountingSheet
    const columNameVsColumnNumber = ZzzSheetOperations.correspondenceObjectAboutColumnNameToColumnNumber(allColumnNames)

    // シートをゆるく保護する
    sheetNames.forEach(sheetName => {
      const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)

      const protectedColumnNumbers = [
        columNameVsColumnNumber['ID'],
        columNameVsColumnNumber['screen_name'],
        columNameVsColumnNumber['tweet_id'],
        columNameVsColumnNumber['日時'],
        columNameVsColumnNumber['URL'],
        columNameVsColumnNumber['全チェック終了？'],
        columNameVsColumnNumber['別ツイート'],
      ]

      protectedColumnNumbers.forEach(protectedColumnNumber => {
        const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(protectedColumnNumber, sheet)

        range.protect() // デフォルトでは自分と自分のグループのみが編集可能（なので大抵はこれでいい）
      })

      console.log(`[DONE] ${sheetName} : シート保護設定`)
    })
  }

  // 既存データを上書きする破壊的メソッドなので注意する
  export const createCheckBoxes = () => {
    const sheetNames = ZzzSheetNames.forCountingSheetNames
    const allColumnNames = ZzzColumnNames.columnNamesOnCountingSheet
    const columNameVsColumnNumber = ZzzSheetOperations.correspondenceObjectAboutColumnNameToColumnNumber(allColumnNames)

    // チェックボックスを入れる
    sheetNames.forEach(sheetName => {
      const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)

      const requiredCheckboxColumnNumbers = [
        columNameVsColumnNumber['ツイートが見られない？'],
        columNameVsColumnNumber['集計対象外？'],
        columNameVsColumnNumber['ふぁぼ済？'],
        columNameVsColumnNumber['二次チェック済？'],
        columNameVsColumnNumber['要レビュー？'],
      ]

      requiredCheckboxColumnNumbers.forEach(requiredCheckboxColumnNumber => {
        const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(requiredCheckboxColumnNumber, sheet)

        ZzzCellOperations.createCheckBoxes(range)
      })
    })
  }

  // 表示形式 -> ラッピング -> はみ出す | 折り返す | 切り詰める
  export const setRappings = () => {
    const sheetNames = ZzzSheetNames.forCountingSheetNames
    const allColumnNames = ZzzColumnNames.columnNamesOnCountingSheet
    const columNameVsColumnNumber = ZzzSheetOperations.correspondenceObjectAboutColumnNameToColumnNumber(allColumnNames)

    sheetNames.forEach(sheetName => {
      const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)

      const kiritsumeruColumnNumbers = [
        columNameVsColumnNumber['screen_name'],
        columNameVsColumnNumber['tweet_id'],
        columNameVsColumnNumber['日時'],
        columNameVsColumnNumber['URL'],
        columNameVsColumnNumber['別ツイート'],
      ]

      kiritsumeruColumnNumbers.forEach(requiredColumnNumber => {
        const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(requiredColumnNumber, sheet)

        ZzzCellOperations.rappingKiritsumeru(range)
      })

      const orikaesuColumnNumbers = [
        columNameVsColumnNumber['内容'],
        columNameVsColumnNumber['備考'],
      ]

      orikaesuColumnNumbers.forEach(requiredColumnNumber => {
        const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(requiredColumnNumber, sheet)

        ZzzCellOperations.rappingOrikaesu(range)
      })
    })
  }

  // 長すぎるので「列」ごとにうまく分けたい
  export const setDefaultConditionalFormats = () => {
    const sheetNames = ZzzSheetNames.forCountingSheetNames
    const allColumnNames = ZzzColumnNames.columnNamesOnCountingSheet
    const columNameVsColumnNumber = ZzzSheetOperations.correspondenceObjectAboutColumnNameToColumnNumber(allColumnNames)

    const requiredReviewColumnNumber = columNameVsColumnNumber['要レビュー？']
    const requiredReviewColumnAlphabet = ZzzConverters.convertColumnNumberToAlphabet(requiredReviewColumnNumber)

    const completedSecondCheckColumnNumber = columNameVsColumnNumber['二次チェック済？']
    const completedSecondCheckAlphabet = ZzzConverters.convertColumnNumberToAlphabet(completedSecondCheckColumnNumber)

    const formula = `=IF(AND(${requiredReviewColumnAlphabet}2=FALSE,${completedSecondCheckAlphabet}2=TRUE),"🌞","☔")`

    // 「全チェック終了？」列
    sheetNames.forEach(sheetName => {
      const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)
      const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(
        columNameVsColumnNumber['全チェック終了？'],
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
    })

    // 「要レビュー？」列
    sheetNames.forEach(sheetName => {
      const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)
      const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(
        columNameVsColumnNumber['要レビュー？'],
        sheet
      )

      ZzzConditionalFormats.setColorToRangeInSpecificCondition(
        range,
        sheet,
        'TRUE',
        '#ffc0cb' // Red
      )
    })

    // 「二次チェック済？」列
    sheetNames.forEach(sheetName => {
      const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)
      const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(
        columNameVsColumnNumber['二次チェック済？'],
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
    })

    // 「ふぁぼ済？」列
    sheetNames.forEach(sheetName => {
      const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)
      const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(
        columNameVsColumnNumber['ふぁぼ済？'],
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
    })
  }

  export const setGrayBackGroundInSpecificCondition = () => {
    const sheetNames = ZzzSheetNames.forCountingSheetNames
    const allColumnNames = ZzzColumnNames.columnNamesOnCountingSheet
    const columNameVsColumnNumber = ZzzSheetOperations.correspondenceObjectAboutColumnNameToColumnNumber(allColumnNames)

    let columnAlphabet: string
    let newRule: GoogleAppsScript.Spreadsheet.ConditionalFormatRule

    sheetNames.forEach(sheetName => {
      const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)
      const rules = sheet.getConditionalFormatRules()

      for (let i = 2; i <= 101; i++) {
        columnAlphabet = ZzzConverters.convertColumnNumberToAlphabet(columNameVsColumnNumber['集計対象外？'])

        newRule = ZzzConditionalFormats.getRuleToSetGrayBackgroundToAllRowCellsInSpecificCondition(
          i,
          sheet,
          `=$${columnAlphabet}$${i}=TRUE`,
          sheet.getRange(i, 1, 1, 100)
        )
        rules.push(newRule)

        columnAlphabet = ZzzConverters.convertColumnNumberToAlphabet(columNameVsColumnNumber['ツイートが見られない？'])

        newRule = ZzzConditionalFormats.getRuleToSetGrayBackgroundToAllRowCellsInSpecificCondition(
          i,
          sheet,
          `=$${columnAlphabet}$${i}=TRUE`,
          sheet.getRange(i, 1, 1, 100)
        )
        rules.push(newRule)
      }

      sheet.setConditionalFormatRules(rules)

      console.log(`[END] ${sheetName} : setGrayBackGroundInSpecificCondition`)
    })
  }
}
