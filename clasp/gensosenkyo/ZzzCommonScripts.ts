namespace ZzzCommonScripts {
  export const RemoveAtMarkAndBlank = (text: string) => {
    let removedAtmarkAndBlankText: string

    removedAtmarkAndBlankText = text.replace('@', '')
    removedAtmarkAndBlankText = removedAtmarkAndBlankText.replace(' ', '')

    return removedAtmarkAndBlankText
  }
}
