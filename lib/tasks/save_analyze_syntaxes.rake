namespace :save_analyze_syntaxes do
  desc '全ツイートを NaturalLanguage::Analyzer で解析して保存する'
  task tweets: :environment do
    client = CloudLanguage.client

    ActiveRecord::Base.transaction do
      Tweet.all.each do |tweet|
        NaturalLanguage::Analyzer.save_analyze_syntax_record(client, tweet)
      end
    end
  end

  desc '全DMを NaturalLanguage::Analyzer で解析して保存する'
  task direct_messages: :environment do
    client = CloudLanguage.client

    ActiveRecord::Base.transaction do
      DirectMessage.all.each do |direct_message|
        NaturalLanguage::Analyzer.save_analyze_syntax_record(client, direct_message)
      end
    end
  end
end
