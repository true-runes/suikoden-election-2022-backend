module Counting
  module Checkers
    class BonusVotes
      def initialize
        @excluded_character_names = Rails.application.credentials.excluded_not_in_db_character_names
      end

      def character_names_who_not_exist_in_chara_db
        in_local_db_character_names = CountingBonusVote.all.pluck(:character_name).compact_blank.uniq

        in_local_db_character_names.each do |character_name|
          next if character_name.in?(@excluded_character_names)

          raise StandardError, "#{character_name} は キャラDB の中に存在しません。" unless o.in_local_db_character_names?(character_name)
        end
      end
    end
  end
end
