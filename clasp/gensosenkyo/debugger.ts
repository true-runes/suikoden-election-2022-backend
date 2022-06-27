const debugFunction = () => {
  const sheet = ZzzSheetOperations.changeActiveSheetTo('シート288')

  ZzzSheetOperations.setBackgroundColorToSpecificColumnNumberOnSheet(
    3,
    sheet,
    'white'
  )
}
