namespace :update_character_db do
  desc 'キャラDBのデータを更新する'
  task exec: :environment do
    ActiveRecord::Base.transaction do
      # ササライ：「２」追加
      c = Character.find_by(name: 'ササライ')
      products = Product.where(
        name: [
          '幻想水滸伝II',
          '幻想水滸伝III',
          '幻想水滸外伝Vol.2',
        ]
      )
      c.update!(products: products)

      # ジェレミー：「２」削除
      c = Character.find_by(name: 'ジェレミー')
      products = Product.where(
        name: [
          '幻想水滸伝IV',
          'Rhapsodia',
        ]
      )
      c.update!(products: products)

      # ジョーカー（ワン）：「外伝２」追加
      c = Character.find_by(name: 'ジョーカー（ワン）')
      products = Product.where(
        name: [
          '幻想水滸伝III',
          '幻想水滸外伝Vol.2',
        ]
      )
      c.update!(products: products)

      # ネオス：「２」削除
      c = Character.find_by(name: 'ネオス')
      products = Product.where(
        name: [
          '幻想水滸伝 紡がれし百年の時',
        ]
      )
      c.update!(products: products)

      # ハーン・カニンガム：「２」追加
      c = Character.find_by(name: 'ハーン・カニンガム')
      products = Product.where(
        name: [
          '幻想水滸伝II',
        ]
      )
      c.update!(products: products)
    end
  end
end
