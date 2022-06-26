namespace ZzzDebugFunctions {
  export const clearConditionalFormatsOnAllSheets = () => {
    ZzzSheetOperations.applyFunctionToAllCountingSheets((sheet) => {
      sheet.clearConditionalFormatRules();
    })
  }
}
