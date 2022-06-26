const _debugFunction = () => {
  // sheet.getRange は (行番号, 列番号, 行数, 列数)
  // (3, 2, 4, 5) は B3:F6 になる
  // 単純な値セットは getRange().setValue(VALUE) だが、Apps Script 側ではやりたくない

  const sheet = ZzzSheetOperations.changeActiveSheetTo('シート1')
  const range = sheet.getRange(3, 2, 4, 5)

  ZzzConditionalFormats.setColorToRangeInSpecificCondition(
    range,
    sheet,
    'a',
    '#ffc0cb'
  )
}
