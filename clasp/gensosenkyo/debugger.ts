const debugFunction = () => {
  const colNameToNumber = ZzzColumnNames.colNameToNumber()

  const sheet = ZzzSheetOperations.changeActiveSheetTo('シート123')

  ZzzSheetOperations.setBackgroundColorToSpecificColumnNumberOnSheet(
    colNameToNumber['ふぁぼ済？'],
    sheet,
    'gray'
  )

  ZzzSheetOperations.setValueToSpecificColumnNumberOnSheet(
    colNameToNumber['ふぁぼ済？'],
    sheet,
    'TRUE'
  )
}
