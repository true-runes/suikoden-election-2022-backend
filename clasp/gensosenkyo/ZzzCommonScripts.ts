namespace ZzzCommonScripts {
  export const RemoveAtMarkAndBlank = (text: string) => {
    let removedAtmarkAndBlankText: string

    removedAtmarkAndBlankText = text.replace('@', '')
    removedAtmarkAndBlankText = removedAtmarkAndBlankText.replace(' ', '')

    return removedAtmarkAndBlankText
  }

  export const showStartAndEndLogger = (fn, displayLogText = 'showStartAndEndLogger') => {
    console.log(`[START] ${displayLogText}`)
    fn()
    console.log(`[END] ${displayLogText}`)
  }
}
