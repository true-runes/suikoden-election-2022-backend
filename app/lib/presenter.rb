module Presenter
  class UniteAttacks
    def self.character_names(attack)
      character_names = [
        attack.chara_1,
        attack.chara_2,
        attack.chara_3,
        attack.chara_4,
        attack.chara_5,
        attack.chara_6,
      ]

      character_names.compact_blank!
      character_names.compact! # これはもはや不要っぽい
      character_names.sort!

      character_names.join('＆')
    end
  end

  class Common
    def self.japanese_date_strftime(time, with_day_of_the_week: false)
      days_of_the_week = ['日', '月', '火', '水', '木', '金', '土']

      this_day_of_the_week_with_brackets = if with_day_of_the_week
                                             "（#{days_of_the_week[time.wday]}）"
                                           else
                                             ""
                                           end

      time.strftime("%Y年%m月%d日#{this_day_of_the_week_with_brackets}")
    end

    def self.japanese_clock_time_strftime(time, with_seconds: true)
      str = with_seconds ? "%H時%M分%S秒" : "%H時%M分"

      time.strftime(str)
    end

    def self.normalized_screen_name(screen_name)
      return '' if screen_name.blank?

      screen_name.gsub!(' ', '')
      screen_name.gsub('@', '')
    end

    def self.formatted_product_names_for_tweet(character_name)
      return '' if Character.find_by(name: character_name).blank?

      products = Character.find_by(name: character_name).products

      return '' if products.blank?

      product_name_long_to_short = {
        '幻想水滸伝' => 'I',
        '幻想水滸伝II' => 'II',
        '幻想水滸外伝Vol.1' => '外1',
        '幻想水滸外伝Vol.2' => '外2',
        '幻想水滸伝III' => 'III',
        '幻想水滸伝IV' => 'IV',
        'Rhapsodia' => 'R',
        '幻想水滸伝V' => 'V',
        '幻想水滸伝ティアクライス' => 'TK',
        '幻想水滸伝 紡がれし百年の時' => '紡時'
      }

      "(#{products.map { |product| product_name_long_to_short[product.name] }.join(',')})"
    end
  end

  class Counting
    # { "key1" => 100, "key2" => 99, "key3" => 99, "key4" => 98 } の入力に対し、
    # { "key1" => 1, "key2" => 2, "key3" => 2, "key4" => 3 } を返す
    # 票数の降順でソートしてあることが前提となるので注意する
    def self.key_to_rank_number_by_sosenkyo_style(hash_records)
      current_rank = 1
      key_to_rank_number = {}
      hash_records_keys = hash_records.keys

      hash_records_keys.each_with_index do |key, index|
        if index == 0
          key_to_rank_number[key] = current_rank

          next
        end

        if hash_records[key] == hash_records[hash_records_keys[index - 1]]
          key_to_rank_number[key] = key_to_rank_number[hash_records_keys[index - 1]]
        else
          current_rank += 1

          key_to_rank_number[key] = current_rank
        end
      end

      key_to_rank_number
    end
  end
end
