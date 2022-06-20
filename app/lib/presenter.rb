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
end
