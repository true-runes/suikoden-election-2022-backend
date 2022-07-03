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
  end

  class Counting
    def set_rank_number
      # 同数の場合には上に寄せる
    end
  end
end
