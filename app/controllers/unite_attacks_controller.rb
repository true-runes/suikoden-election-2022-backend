class UniteAttacksController < ApplicationController
  def index
    # unite_attacks
    # params[:title] が s2 のとき、
    # title = Title.find_by(name: "s2")
    # title_id = title.id
    # unite_attacks = UniteAttack.where(title_id: title_id)
    # unite_attacks.map do |unite_attack|
    #   {
    #     name: unite_attack.name,
    #     character_names: unite_attack.characters.pluck(:name),
    #   }
    # end
    # params[:title] がないときはどうしよう、s1でいっか

    render json: s2
  end

  private

  def s2
    [
      {
        name: "おさななじみ攻撃",
        character_names: [
          "主人公",
          "ジョウイ",
        ],
        note: "ジョウイが覚醒した時に覚醒する攻撃",
      },
      {
        name: "兄弟攻撃",
        character_names: [
          "主人公",
          "ナナミ",
        ],
        note: "ナナミが覚醒した時に覚醒する攻撃",
      },
    ]
  end
end
