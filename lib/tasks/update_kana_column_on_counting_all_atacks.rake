namespace :update_kana_column_on_counting_all_atacks do
  desc 'ソート用カラムを CountingUniteAttack の各レコードに追加する'
  task exec: :environment do
    product_name_to_sheet_name = {
      '幻想水滸伝' => '幻水I',
      '幻想水滸伝II' => '幻水II',
      '幻想水滸伝III' => '幻水III',
      '幻想水滸伝IV' => '幻水IV',
      'ラプソディア' => 'Rhapsodia',
      '幻想水滸伝V' => '幻水V',
      '幻想水滸伝ティアクライス' => 'TK',
      '幻想水滸伝 紡がれし百年の時' => '紡時'
    }

    ActiveRecord::Base.transaction do
      CountingUniteAttack.all.each do |record|
        next if record.is_invisible || record.is_out_of_counting || record.product_name.blank? || record.unite_attack_name.blank?

        origin_records = if record.product_name == 'ラプソディア' && record.unite_attack_name == 'Wリーダー攻撃'
          # 特例（スプレッドシートからのデータは厳密にスクリーニングをしておくべき）
          OnRawSheetUniteAttack.where(
            sheet_name: product_name_to_sheet_name[record.product_name],
            name: 'Ｗリーダー攻撃'
          )
                         else
          OnRawSheetUniteAttack.where(
            sheet_name: product_name_to_sheet_name[record.product_name],
            name: record.unite_attack_name
          )
                         end

        raise if origin_records.size != 1

        kana = origin_records.first.kana
        record.update!(kana: kana) if record.kana != kana
      end
    end
  end
end
