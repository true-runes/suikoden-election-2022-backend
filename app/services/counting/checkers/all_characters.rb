module Counting
  module Checkers
    class AllCharacters
      def self.over_three_votes_users
        User.all.select(&:on_all_character_division_voting_over_three?)
      end

      def self.vote_to_the_same_characters_users
        User.all.select(&:on_all_character_division_voting_to_the_same_characters?)
      end
    end
  end
end
