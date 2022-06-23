module Presenter
  class UniteAttacks
    # いったん愚直に
    def self.character_names(attack)
      character_names = attack.chara_1
      character_names = "#{character_names}＆#{attack.chara_2}" if attack.chara_2.present?
      character_names = "#{character_names}＆#{attack.chara_3}" if attack.chara_3.present?
      character_names = "#{character_names}＆#{attack.chara_4}" if attack.chara_4.present?
      character_names = "#{character_names}＆#{attack.chara_5}" if attack.chara_5.present?
      character_names = "#{character_names}＆#{attack.chara_6}" if attack.chara_6.present?

      character_names
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
      screen_name.gsub!(' ', '')
      screen_name.gsub('@', '')
    end
  end
end
