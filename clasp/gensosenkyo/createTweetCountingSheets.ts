const createTweetCountingSheets = () => {
  const sheet = ZzzSheetOperations.changeActiveSheetTo('ツイート')
  const columnNames = ZzzColumnNames.columnNamesOnBonusVotesSheet()
  const range = sheet.getRange(1, 1, 1, columnNames.length)
  // 'sheet.getRange' に対して 'setValues' するときの引数は二次元配列になる
  range.setValues([columnNames])
}
