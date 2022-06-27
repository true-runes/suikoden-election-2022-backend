namespace createTweetCountingSheets {
  // NOTE: 約6分かかる
  export const createAllSheets = () => {
    const sheetNames = ZzzSheetNames.allSheetNames

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

  export const setColumnNames = (category = 'mainDivision') => {
    ZzzSheetOperations.applyFunctionToAllCountingSheets(
      (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
        ZzzCellOperations.setFirstRowNames(sheet, category)
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

  export const setColumnWidths = (category = '') => {
    const colNameToNumber = ZzzColumnNames.colNameToNumber(category)

    ZzzSheetOperations.applyFunctionToAllCountingSheets(
      (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
        sheet.setColumnWidth(colNameToNumber['ID'], 40)
        sheet.setColumnWidth(colNameToNumber['screen_name'], 30)
        sheet.setColumnWidth(colNameToNumber['日時'], 30)
        sheet.setColumnWidth(colNameToNumber['全終了？'], 40)
        sheet.setColumnWidth(colNameToNumber['集計対象外？'], 90)
        sheet.setColumnWidth(colNameToNumber['二次チェック済？'], 130)
        sheet.setColumnWidth(colNameToNumber['備考'], 100)
        sheet.setColumnWidth(colNameToNumber['要レビュー？'], 90)
        sheet.setColumnWidth(colNameToNumber['キャラ1 or 作品名'], 140)
        sheet.setColumnWidth(colNameToNumber['キャラ2 or 協力攻撃名'], 140)
        sheet.setColumnWidth(colNameToNumber['キャラ3'], 140)

        if (category === 'directMessage') {
          sheet.setColumnWidth(colNameToNumber['内容'], 300)
          sheet.setColumnWidth(colNameToNumber['dm_id'], 50)
          sheet.setColumnWidth(colNameToNumber['DMが見られない？'], 120)
          sheet.setColumnWidth(colNameToNumber['対応済み？'], 90)
        } else {
          sheet.setColumnWidth(colNameToNumber['内容'], 200)
          sheet.setColumnWidth(colNameToNumber['tweet_id'], 50)
          sheet.setColumnWidth(colNameToNumber['URL'], 30)
          sheet.setColumnWidth(colNameToNumber['別ツイ'], 40)
          sheet.setColumnWidth(colNameToNumber['ツイ見られない？'], 120)
          sheet.setColumnWidth(colNameToNumber['ふぁぼ済？'], 90)
        }
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
  export const createCheckBoxes = (category = '') => {
    const colNameToNumber = ZzzColumnNames.colNameToNumber(category)

    ZzzSheetOperations.applyFunctionToAllCountingSheets(
      (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
        const requiredCheckboxColumnNumbers = [
          colNameToNumber['集計対象外？'],
          colNameToNumber['二次チェック済？'],
          colNameToNumber['要レビュー？'],
        ]

        if (category === 'directMessage') {
          requiredCheckboxColumnNumbers.push(colNameToNumber['対応済み？'])
          requiredCheckboxColumnNumbers.push(colNameToNumber['DMが見られない？'])
        } else {
          requiredCheckboxColumnNumbers.push(colNameToNumber['ふぁぼ済？'])
          requiredCheckboxColumnNumbers.push(colNameToNumber['ツイ見られない？'])
        }

        requiredCheckboxColumnNumbers.forEach(requiredCheckboxColumnNumber => {
          const range = ZzzCellOperations.getRangeSpecificColumnRow2ToRow101(requiredCheckboxColumnNumber, sheet)

          ZzzCellOperations.createCheckBoxes(range)
        })
      },
      'チェックボックスを追加しました'
    )
  }

  // 表示形式 -> ラッピング -> はみ出す | 折り返す | 切り詰める
  export const setRappings = (category = '') => {
    const colNameToNumber = ZzzColumnNames.colNameToNumber('directMessage')

    ZzzSheetOperations.applyFunctionToAllCountingSheets(
      (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
        const kiritsumeruColumnNumbers = [
          colNameToNumber['screen_name'],
          colNameToNumber['日時'],
        ]

        if (category !== 'directMessage') {
          kiritsumeruColumnNumbers.push(colNameToNumber['別ツイ']) // DMでは存在しないカラム
          kiritsumeruColumnNumbers.push(colNameToNumber['tweet_id']) // DMでは存在しないカラム
          kiritsumeruColumnNumbers.push(colNameToNumber['URL']) // DMでは存在しないカラム
        }

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

  export const setDefaultConditionalFormats = (category = '') => {
    ZzzSheetOperations.applyFunctionToAllCountingSheets(
      (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
        // 「全終了？」列
        // FIXME:
        ZzzConditionalFormats.setInitToIsAllCompletedColumn(sheet, category)

        // 「要レビュー？」列
        ZzzConditionalFormats.setInitToIsRequiredReview(sheet, category)

        // 「二次チェック済？」列
        ZzzConditionalFormats.setInitToIsCompletedSecondCheck(sheet, category)

        if (category === 'directMessage') {
          // 「対応済み？」列
          ZzzConditionalFormats.setInitToIsCompletedDMResponse(sheet, category)
        } else {
          // 「ふぁぼ済？」列
          ZzzConditionalFormats.setInitToIsCompletedFavorite(sheet, category)
        }
      },
      '「条件付き書式」の設定'
    )
  }

  // 特定条件において行全体を灰色の背景にする「条件付き書式」
  export const setGrayBackGroundInSpecificCondition = (category = '') => {
    const colNameToNumber = ZzzColumnNames.colNameToNumber(category)
    let columnAlphabet: string
    let newRule: GoogleAppsScript.Spreadsheet.ConditionalFormatRule

    ZzzSheetOperations.applyFunctionToAllCountingSheets(
      (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
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

          if (category === 'directMessage') {
            columnAlphabet = ZzzConverters.convertColumnNumberToAlphabet(colNameToNumber['DMが見られない？'])
          } else {
            columnAlphabet = ZzzConverters.convertColumnNumberToAlphabet(colNameToNumber['ツイ見られない？'])
          }

          newRule = ZzzConditionalFormats.getRuleToSetGrayBackgroundToAllRowCellsInSpecificCondition(
            i,
            sheet,
            `=$${columnAlphabet}$${i}=TRUE`,
            sheet.getRange(i, 1, 1, 100)
          )
          rules.push(newRule)
        }

        sheet.setConditionalFormatRules(rules)
      },
      '特定条件において行全体を灰色の背景にする「条件付き書式」'
    )
  }

  // サジェスト用に「入力規則」を設定する（重い）
  export const setDataValidationsForSuggestions = (
    category: 'mainDivision' | 'bonusVote' | 'directMessage'
  ) => {
    const colNameToNumber = ZzzColumnNames.colNameToNumber(category)

    const targetColumnNumbers = [
      colNameToNumber['キャラ1 or 作品名'],
      colNameToNumber['キャラ2 or 協力攻撃名'],
      colNameToNumber['キャラ3'],
      colNameToNumber['キャラ4'],
      colNameToNumber['キャラ5'],
      colNameToNumber['キャラ6'],
      colNameToNumber['キャラ7'],
      colNameToNumber['キャラ8'],
      colNameToNumber['キャラ9'],
      colNameToNumber['キャラ10'],
    ]
    const colNumbersWithoutFalsy = targetColumnNumbers.filter(v => v)

    ZzzSheetOperations.applyFunctionToAllCountingSheets(
      (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
        colNumbersWithoutFalsy.forEach(targetColumnNumber => {
          ZzzDataValidation.setDataValidationToCell(
            sheet,
            targetColumnNumber
          )
        })
      },
      '「入力規則」を設定する（サジェスト用）'
    )
  }

  // ここは Ruby 側でデータを入れるときにやればいいので、未使用メソッド
  export const setAllTrueValuesToIsFavoriteColumn = () => {
    const colNameToNumber = ZzzColumnNames.colNameToNumber()

    ZzzSheetOperations.applyFunctionToAllCountingSheets(
      (sheet: GoogleAppsScript.Spreadsheet.Sheet) => {
        ZzzSheetOperations.setValueToSpecificColumnNumberOnSheet(
          colNameToNumber['ふぁぼ済？'],
          sheet,
          'TRUE'
        )
      }
    )
  }
}
