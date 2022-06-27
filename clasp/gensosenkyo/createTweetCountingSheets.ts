namespace createTweetCountingSheets {
  export const createAllSheets = () => {
    const sheetNames = ZzzSheetNames.allSheetNames

    // とてもコストが高い実行内容（シートを一枚作るために約15秒）
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
    ZzzSheetOperations.applyFunctionToAllCountingSheets(
      (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
        ZzzCellOperations.setFirstRowNames(sheet)
      }, '列名を設定しました'
    )
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
    const colNameToNumber = ZzzColumnNames.colNameToNumber()

    ZzzSheetOperations.applyFunctionToAllCountingSheets(
      (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
        sheet.setColumnWidth(colNameToNumber['ID'], 40)
        sheet.setColumnWidth(colNameToNumber['screen_name'], 30)
        sheet.setColumnWidth(colNameToNumber['tweet_id'], 50)
        sheet.setColumnWidth(colNameToNumber['日時'], 30)
        sheet.setColumnWidth(colNameToNumber['URL'], 30)
        sheet.setColumnWidth(colNameToNumber['別ツイ'], 40)
        sheet.setColumnWidth(colNameToNumber['全終了？'], 40)
        sheet.setColumnWidth(colNameToNumber['ツイ見られない？'], 120)
        sheet.setColumnWidth(colNameToNumber['集計対象外？'], 90)
        sheet.setColumnWidth(colNameToNumber['ふぁぼ済？'], 90)
        sheet.setColumnWidth(colNameToNumber['二次チェック済？'], 130)
        sheet.setColumnWidth(colNameToNumber['内容'], 200)
        sheet.setColumnWidth(colNameToNumber['備考'], 100)
        sheet.setColumnWidth(colNameToNumber['要レビュー？'], 90)
        sheet.setColumnWidth(colNameToNumber['キャラ1'], 140)
        sheet.setColumnWidth(colNameToNumber['キャラ2'], 140)
        sheet.setColumnWidth(colNameToNumber['キャラ3'], 140)
      },
      '列幅を指定しました'
    )
  }

  // 既存データを上書きする破壊的メソッドなので注意する
  export const setBanpeis = () => {
    ZzzSheetOperations.applyFunctionToAllCountingSheets(
      (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
        ZzzCellOperations.setLastRowSymbols(sheet)
      },
      '102行目の各セルに "@" を入れました'
    )
  }

  export const setProtectedCells = () => {
    const colNameToNumber = ZzzColumnNames.colNameToNumber()

    ZzzSheetOperations.applyFunctionToAllCountingSheets(
      (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
        const protectedColumnNumbers = [
          colNameToNumber['ID'],
          colNameToNumber['screen_name'],
          colNameToNumber['tweet_id'],
          colNameToNumber['日時'],
          colNameToNumber['URL'],
          colNameToNumber['全終了？'],
          colNameToNumber['別ツイ'],
        ]

        protectedColumnNumbers.forEach(protectedColumnNumber => {
          const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(protectedColumnNumber, sheet)

          range.protect() // デフォルトでは自分と自分のグループのみが編集可
        })
      },
      'シートの保護設定をしました'
    )
  }

  // 既存データを上書きする破壊的メソッドなので注意する
  export const createCheckBoxes = () => {
    const colNameToNumber = ZzzColumnNames.colNameToNumber()

    ZzzSheetOperations.applyFunctionToAllCountingSheets(
      (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
        const requiredCheckboxColumnNumbers = [
          colNameToNumber['ツイ見られない？'],
          colNameToNumber['集計対象外？'],
          colNameToNumber['ふぁぼ済？'],
          colNameToNumber['二次チェック済？'],
          colNameToNumber['要レビュー？'],
        ]

        requiredCheckboxColumnNumbers.forEach(requiredCheckboxColumnNumber => {
          const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(requiredCheckboxColumnNumber, sheet)

          ZzzCellOperations.createCheckBoxes(range)
        })
      },
      'チェックボックスを追加しました'
    )
  }

  // 表示形式 -> ラッピング -> はみ出す | 折り返す | 切り詰める
  export const setRappings = () => {
    const colNameToNumber = ZzzColumnNames.colNameToNumber()

    ZzzSheetOperations.applyFunctionToAllCountingSheets(
      (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
        const kiritsumeruColumnNumbers = [
          colNameToNumber['screen_name'],
          colNameToNumber['tweet_id'],
          colNameToNumber['日時'],
          colNameToNumber['URL'],
          colNameToNumber['別ツイ'],
        ]

        kiritsumeruColumnNumbers.forEach(requiredColumnNumber => {
          const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(requiredColumnNumber, sheet)

          ZzzCellOperations.rappingKiritsumeru(range)
        })

        const orikaesuColumnNumbers = [
          colNameToNumber['内容'],
          colNameToNumber['備考'],
        ]

        orikaesuColumnNumbers.forEach(requiredColumnNumber => {
          const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(requiredColumnNumber, sheet)

          ZzzCellOperations.rappingOrikaesu(range)
        })
      },
      '「表示形式 -> ラッピング」の設定が完了'
    )
  }

  // 長すぎるので「列」ごとにうまく分けたい
  export const setDefaultConditionalFormats = () => {
    const sheetNames = ZzzSheetNames.forCountingSheetNames
    const colNameToNumber = ZzzColumnNames.colNameToNumber()

    const requiredReviewColumnNumber = colNameToNumber['要レビュー？']
    const requiredReviewColumnAlphabet = ZzzConverters.convertColumnNumberToAlphabet(requiredReviewColumnNumber)

    const completedSecondCheckColumnNumber = colNameToNumber['二次チェック済？']
    const completedSecondCheckAlphabet = ZzzConverters.convertColumnNumberToAlphabet(completedSecondCheckColumnNumber)

    const formula = `=IF(AND(${requiredReviewColumnAlphabet}2=FALSE,${completedSecondCheckAlphabet}2=TRUE),"🌞","☔")`

    // 「全終了？」列
    sheetNames.forEach(sheetName => {
      const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)
      const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(
        colNameToNumber['全終了？'],
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
        colNameToNumber['要レビュー？'],
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
        colNameToNumber['二次チェック済？'],
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
        colNameToNumber['ふぁぼ済？'],
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
    const colNameToNumber = ZzzColumnNames.colNameToNumber()

    let columnAlphabet: string
    let newRule: GoogleAppsScript.Spreadsheet.ConditionalFormatRule

    sheetNames.forEach(sheetName => {
      const sheet = ZzzSheetOperations.changeActiveSheetTo(sheetName)
      const rules = sheet.getConditionalFormatRules()

      for (let i = 2; i <= 101; i++) {
        columnAlphabet = ZzzConverters.convertColumnNumberToAlphabet(colNameToNumber['集計対象外？'])

        newRule = ZzzConditionalFormats.getRuleToSetGrayBackgroundToAllRowCellsInSpecificCondition(
          i,
          sheet,
          `=$${columnAlphabet}$${i}=TRUE`,
          sheet.getRange(i, 1, 1, 100)
        )
        rules.push(newRule)

        columnAlphabet = ZzzConverters.convertColumnNumberToAlphabet(colNameToNumber['ツイ見られない？'])

        newRule = ZzzConditionalFormats.getRuleToSetGrayBackgroundToAllRowCellsInSpecificCondition(
          i,
          sheet,
          `=$${columnAlphabet}$${i}=TRUE`,
          sheet.getRange(i, 1, 1, 100)
        )
        rules.push(newRule)
      }

      sheet.setConditionalFormatRules(rules)

      console.log(`[END] ${sheetName} : 特定条件で背景をグレーにする`)
    })
  }
}
