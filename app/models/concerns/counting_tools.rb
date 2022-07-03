module CountingTools
  extend ActiveSupport::Concern

  included do
    scope :other_tweets_exists, -> { where.not(other_tweet_ids_text: '') }
  end

  module ClassMethods
    def foobar; end
  end

  def three_chara_names
    [chara_1, chara_2, chara_3]
  end

  def convert_chara_names_to_array_in_character_and_products_hashes(chara_names)
    result_array = []

    chara_names.each do |chara_name|
      inserted_hash = {}

      inserted_hash['character'] = Character.find_by(name: chara_name)
      inserted_hash['products'] = Character.find_by(name: chara_name).products

      result_array << inserted_hash
    end

    result_array
  end
end
