class Character < ApplicationRecord
  has_many :character_products, dependent: :destroy
  has_many :products, through: :character_products

  has_many :character_nicknames, dependent: :destroy
  has_many :nicknames, through: :character_nicknames

  def product_names_for_result_tweet
    # TODO: 共通の値としてどこかに置きたい
    name_convert_list = {
      '幻想水滸伝' => 'I',
      '幻想水滸伝II' => 'II',
      '幻想水滸外伝Vol.1' => '外伝1',
      '幻想水滸外伝Vol.2' => '外伝2',
      '幻想水滸伝III' => 'III',
      '幻想水滸伝IV' => 'IV',
      'Rhapsodia' => 'R',
      '幻想水滸伝V' => 'V',
      '幻想水滸伝ティアクライス' => 'TK',
      '幻想水滸伝 紡がれし百年の時' => '紡時'
    }

    converted_product_names = products.map do |product|
      name_convert_list[product.name]
    end

    # Character.first.product_names_for_result_tweet #=> "(I,II,外伝2)"
    "(#{converted_product_names.join(',')})"
  end
end
