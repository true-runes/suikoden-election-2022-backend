module Sheets
  module WriteAndUpdate
    module FinalResults
      class UniteAttacks
        def initialize
          @sheet_name = '②協力攻撃部門'
          @column_name_to_index_hash = {
            id: 0,
            順位: 1,
            作品名: 2,
            協力攻撃名: 3,
            全得票数: 4,
            フリガナ: 5,
            ツイートテンプレ: 6
          }
        end

        def exec
          hash_records = CountingUniteAttack.valid_records.ranking
          key_to_rank_number = Presenter::Counting.key_to_rank_number_by_sosenkyo_style(hash_records)
          written_data = []

          hash_records.each_with_index do |(product_name_and_attack_name_and_kana, number_of_votes), index|
            row = []

            rank_number = key_to_rank_number[product_name_and_attack_name_and_kana]
            product_name = product_name_and_attack_name_and_kana[0]
            attack_name = product_name_and_attack_name_and_kana[1]
            kana = product_name_and_attack_name_and_kana[2]
            tweet_template = tweet_template(rank_number, number_of_votes, product_name, attack_name)

            row[@column_name_to_index_hash[:id]] = index + 1
            row[@column_name_to_index_hash[:順位]] = rank_number
            row[@column_name_to_index_hash[:作品名]] = product_name
            row[@column_name_to_index_hash[:協力攻撃名]] = attack_name
            row[@column_name_to_index_hash[:全得票数]] = number_of_votes
            row[@column_name_to_index_hash[:フリガナ]] = kana
            row[@column_name_to_index_hash[:ツイートテンプレ]] = tweet_template

            written_data << row
          end

          delete

          write(written_data.sort_by { |row| [row[1], row[5]] })
        end

        def tweet_template(rank_number, number_of_votes, product_name, attack_name)
          rank = rank_number
          text_rank_and_votes = "[第#{rank}位] #{number_of_votes}票"
          text_hashtags = "#幻水総選挙開票中\n#幻水総選挙2022"

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

          origin_record = if product_name == 'ラプソディア' && attack_name == 'Wリーダー攻撃'
            # 特例（スプレッドシートからのデータは厳密にスクリーニングをしておくべき）
            OnRawSheetUniteAttack.find_by(
              sheet_name: product_name_to_sheet_name[product_name],
              name: 'Ｗリーダー攻撃'
            )
                          else
            OnRawSheetUniteAttack.find_by(
              sheet_name: product_name_to_sheet_name[product_name],
              name: attack_name
            )
          end

          character_names = Presenter::UniteAttacks.character_names(origin_record)
          annotation = origin_record.page_annotation.present? ? "※#{origin_record.page_annotation}\n" : ''

          inserted_hash = {}
          inserted_hash[:rank] = rank
          inserted_hash[:text] = <<~TWEET
            #{text_rank_and_votes}
            #{product_name}
            #{attack_name}
            （#{character_names}）
            #{annotation}
            #{text_hashtags}
          TWEET
          inserted_hash[:text].chomp!

          inserted_hash[:text]
        end

        def write(written_data)
          SheetData.write_rows(
            sheet_id: ENV.fetch('COUNTING_FINAL_RESULTS_SHEET_ID', nil),
            range: "#{@sheet_name}!A2", # 始点
            values: written_data
          )
        end

        def delete
          SheetData.write_rows(
            sheet_id: ENV.fetch('COUNTING_FINAL_RESULTS_SHEET_ID', nil),
            range: "#{@sheet_name}!A2:G501",
            values: [[''] * 7] * 500 # A列からG列までの列の 500行 を空文字で埋める
          )
        end
      end
    end
  end
end
