namespace ZzzCommonScripts {
  export const RemoveAtMarkAndBlank = (text: string) => {
    let removedAtmarkAndBlankText: string

    removedAtmarkAndBlankText = text.replace('@', '')
    removedAtmarkAndBlankText = removedAtmarkAndBlankText.replace(' ', '')

    return removedAtmarkAndBlankText
  }

  export const showStartAndEndLogger = (fn, displayText = 'showStartAndEndLogger') => {
    console.log(`[START] ${displayText}`)
    fn()
    console.log(`[END] ${displayText}`)
  }
}
