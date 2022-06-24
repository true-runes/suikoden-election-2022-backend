module NaturalLanguage
  class SuggestUniteAttackNames
    # 現状、単にデータベースの値を見ているだけなので "NaturalLanguage" ではない
    def self.exec(tweet_or_dm)
      content_text = tweet_or_dm.content_text

      # 戻り値は {:title=>"幻想水滸伝IV", :attack_name=>"麗しの友情攻撃"} の形になる
      exec_by_text(content_text)
    end

    # 完全一致で調べている
    def self.exec_by_text(content_text)
      return { title: '', attack_name: '' } if content_text.nil? || content_text.lines.size < 3

      content_text_title_name = content_text.lines[0].chomp
      content_text_attack_name = content_text.lines[1].chomp

      found_title_name = title_names.find { |title_name| title_name == content_text_title_name }

      attack_names = OnRawSheetUniteAttack.where(
        sheet_name: convert_title_name_to_sheet_name(found_title_name)
      ).pluck(:name, :name_en).flatten
      found_attack_name = attack_names.find { |attack_name| attack_name == content_text_attack_name}

      { title: found_title_name || '', attack_name: found_attack_name || '' }
    end

    def self.title_names
      [
        '幻想水滸伝',
        'Suikoden',
        '幻想水滸伝II',
        'Suikoden II',
        '幻想水滸伝III',
        'Suikoden III',
        '幻想水滸伝IV',
        'Suikoden IV',
        'ラプソディア',
        'Suikoden Tactics',
        '幻想水滸伝V',
        'Suikoden V',
        '幻想水滸伝ティアクライス',
        'Suikoden Tierkreis',
        '幻想水滸伝 紡がれし百年の時',
        'Suikoden The Woven Web of a Century',
      ]
    end

    def self.convert_title_name_to_sheet_name(title_name)
      {
        '幻想水滸伝' => '幻水I',
        'Suikoden' => '幻水I',
        '幻想水滸伝II' => '幻水II',
        'Suikoden II' => '幻水II',
        '幻想水滸伝III' => '幻水III',
        'Suikoden III' => '幻水III',
        '幻想水滸伝IV' => '幻水IV',
        'Suikoden IV' => '幻水IV',
        'ラプソディア' => 'Rhapsodia',
        'Suikoden Tactics' => 'Rhapsodia',
        '幻想水滸伝V' => '幻水V',
        'Suikoden V' => '幻水V',
        '幻想水滸伝ティアクライス' => 'TK',
        'Suikoden Tierkreis' => 'TK',
        '幻想水滸伝 紡がれし百年の時' => '紡時',
        'Suikoden The Woven Web of a Century' => '紡時'
      }[title_name]
    end
  end
end
