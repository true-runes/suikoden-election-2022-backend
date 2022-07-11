#!/bin/bash -xe

# 単体・①オールキャラ部門
bin/rails runner 'Sheets::WriteAndUpdate::FinalResults::AllCharactersStandAlone.new.exec'
# bin/rails runner 'Sheets::WriteAndUpdate::FinalResults::UniteAttacks.new.exec'

# ボ・お題小説
bin/rails runner 'Sheets::WriteAndUpdate::FinalResults::BonusVotes::ShortStories.new.exec'

# ボ・開票イラスト
bin/rails runner 'Sheets::WriteAndUpdate::FinalResults::BonusVotes::ResultIllustrations.new.exec'

# ボ・推し台詞
bin/rails runner 'Sheets::WriteAndUpdate::FinalResults::BonusVotes::FavQuotes.new.exec'

# ボ・選挙運動
bin/rails runner 'Sheets::WriteAndUpdate::FinalResults::BonusVotes::SosenkyoCampaigns.new.exec'

# ボ・OP・CLイラスト（オールキャラ）
bin/rails runner 'Sheets::WriteAndUpdate::FinalResults::BonusVotes::OpClIllustrations.new.exec'

# 最終・①オールキャラ部門

exit 0
