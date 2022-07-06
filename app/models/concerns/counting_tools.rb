module CountingTools
  extend ActiveSupport::Concern

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

    # 配列の各要素は { character => Character, products => [Product] } のハッシュになる
    result_array
  end
end
