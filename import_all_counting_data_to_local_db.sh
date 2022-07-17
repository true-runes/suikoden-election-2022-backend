#!/bin/bash -xe

bin/rails runner 'CountingAllCharacter.destroy_all'
bin/rails import_counting_all_characters:exec_all
bin/rails fix_dm_counting:exec

# 協力攻撃部門
# bin/rails runner 'CountingUniteAttack.destroy_all'
# bin/rails import_counting_unite_attacks:exec_all

bin/rails runner 'CountingBonusVote.destroy_all'
bin/rails import_counting_bonus_votes:exec_all

# 開票イラストデータは独立しているのでここでインポートする
bin/rails runner 'puts Sheets::ResultIllustrationApplications.import_totallings_data_to_database'

exit 0
