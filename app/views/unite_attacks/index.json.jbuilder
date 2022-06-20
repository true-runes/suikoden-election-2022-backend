json.array! @attacks do |attack|
  json.id attack.id
  json.name attack.name
  json.kana attack.kana
  json.name_en attack.name_en
  json.chara_1 attack.chara_1
  json.chara_2 attack.chara_2
  json.chara_3 attack.chara_3
  json.chara_4 attack.chara_4
  json.chara_5 attack.chara_5
  json.chara_6 attack.chara_6
  json.page_annotation attack.page_annotation
  json.character_names Presenter::UniteAttacks.character_names(attack)
end
