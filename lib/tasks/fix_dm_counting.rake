namespace :fix_dm_counting do
  desc 'DMの Counting レコードを修正する'
  task exec: :environment do
    ActiveRecord::Base.transaction do
      # ファーガス
      dm = DirectMessage.find_by(id_number: 1540359738558676997)
      c = CountingAllCharacter.find_by(direct_message_id: dm.id)

      c.update!(chara_3: 'ファーガス')

      # ひよこちゃん
      dm = DirectMessage.find_by(id_number: 1540361197450452996)
      c = CountingAllCharacter.find_by(direct_message_id: dm.id)

      c.update!(chara_3: 'ひよこちゃん')

      # テスラ
      dm = DirectMessage.find_by(id_number: 1541028176725282821)
      c = CountingAllCharacter.find_by(direct_message_id: dm.id)

      c.update!(chara_3: 'テスラ')
    end
  end
end
