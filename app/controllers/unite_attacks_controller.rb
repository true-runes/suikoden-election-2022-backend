class UniteAttacksController < ApplicationController
  def index
    # TODO: 設定ファイル的なものから持ってきたい
    convert_title_param_to_sheet_name = {
      "s1" => "幻水I",
      "s2" => "幻水II",
      "s3" => "幻水III",
      "s4" => "幻水IV",
      "tactics" => "Rhapsodia",
      "s5" => "幻水V",
      "tk" => "TK",
      "woven" => "紡時"
    }[params[:title]]

    attacks = OnRawSheetUniteAttack.where(sheet_name: convert_title_param_to_sheet_name)

    attacks = attacks.order(kana: :asc) if params[:order] == 'kana'

    return_array = []
    attacks.each do |attack|
      return_hash = {
        id: attack.id,
        name: attack.name,
        kana: attack.kana,
        name_en: attack.name_en,
        chara_1: attack.chara_1,
        chara_2: attack.chara_2,
        chara_3: attack.chara_3,
        chara_4: attack.chara_4,
        chara_5: attack.chara_5,
        chara_6: attack.chara_6,
        page_annotation: attack.page_annotation,
        character_names: character_names(attack)
      }

      return_array.push(return_hash)
    end

    render json: return_array.to_json
  end

  private

  # いったん愚直に
  def character_names(attack)
    character_names = attack.chara_1
    character_names = "#{character_names}＆#{attack.chara_2}" if attack.chara_2.present?
    character_names = "#{character_names}＆#{attack.chara_3}" if attack.chara_3.present?
    character_names = "#{character_names}＆#{attack.chara_4}" if attack.chara_4.present?
    character_names = "#{character_names}＆#{attack.chara_5}" if attack.chara_5.present?
    character_names = "#{character_names}＆#{attack.chara_6}" if attack.chara_6.present?

    character_names
  end
end
