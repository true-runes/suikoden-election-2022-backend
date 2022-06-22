# rubocop:disable Metrics/BlockLength
namespace :import_tweets do
  desc 'ツイートのインポート #幻水総選挙2022'
  task gss2022: :environment do
    tweets = BySearchWordTweet
             .where(search_word: "#幻水総選挙2022")
             .where(tweeted_at: Time.zone.parse("2022-05-01").end_of_day..Time.zone.parse("2022-07-30").end_of_day)
             .remove_duplicated
             .remove_retweet
             .remove_specific_user_with_id_number(1471724029)
             .remove_specific_user_with_id_number(1388758231825018881)
             .order(tweeted_at: :asc)

    Tweets::Importer::FromTweetStorage.exec(tweets: tweets)

    puts '[DONE] ツイートのインポート #幻水総選挙2022'
  end

  desc 'ツイートのインポート #幻水総選挙2022協力攻撃'
  task unite_attacks: :environment do
    tweets = BySearchWordTweet
             .where(search_word: "#幻水総選挙2022協力攻撃")
             .where(tweeted_at: Time.zone.parse("2022-05-01").end_of_day..Time.zone.parse("2022-07-30").end_of_day)
             .remove_duplicated
             .remove_retweet
             .remove_specific_user_with_id_number(1471724029)
             .remove_specific_user_with_id_number(1388758231825018881)
             .order(tweeted_at: :asc)

    Tweets::Importer::FromTweetStorage.exec(tweets: tweets)

    puts '[DONE] ツイートのインポート #幻水総選挙2022協力攻撃'
  end

  desc 'ツイートのインポート #幻水総選挙お題小説'
  task short_stories: :environment do
    tweets = BySearchWordTweet
             .where(search_word: "#幻水総選挙お題小説")
             .where(tweeted_at: Time.zone.parse("2022-05-01").end_of_day..Time.zone.parse("2022-07-30").end_of_day)
             .remove_duplicated
             .remove_retweet
             .remove_specific_user_with_id_number(1471724029)
             .remove_specific_user_with_id_number(1388758231825018881)
             .order(tweeted_at: :asc)

    Tweets::Importer::FromTweetStorage.exec(tweets: tweets)

    puts '[DONE] ツイートのインポート #幻水総選挙お題小説'
  end

  desc 'ツイートのインポート #幻水総選挙推し台詞'
  task fav_quotes: :environment do
    tweets = BySearchWordTweet
             .where(search_word: "#幻水総選挙推し台詞")
             .where(tweeted_at: Time.zone.parse("2022-05-01").end_of_day..Time.zone.parse("2022-07-30").end_of_day)
             .remove_duplicated
             .remove_retweet
             .remove_specific_user_with_id_number(1471724029)
             .remove_specific_user_with_id_number(1388758231825018881)
             .order(tweeted_at: :asc)

    Tweets::Importer::FromTweetStorage.exec(tweets: tweets)

    puts '[DONE] ツイートのインポート #幻水総選挙推し台詞'
  end

  desc 'ツイートのインポート #幻水総選挙運動'
  task sosenkyo_campaigns: :environment do
    tweets = BySearchWordTweet
             .where(search_word: "#幻水総選挙運動")
             .where(tweeted_at: Time.zone.parse("2022-05-01").end_of_day..Time.zone.parse("2022-07-30").end_of_day)
             .remove_duplicated
             .remove_retweet
             .remove_specific_user_with_id_number(1471724029)
             .remove_specific_user_with_id_number(1388758231825018881)
             .order(tweeted_at: :asc)

    Tweets::Importer::FromTweetStorage.exec(tweets: tweets)

    puts '[DONE] ツイートのインポート #幻水総選挙運動'
  end
end
# rubocop:enable Metrics/BlockLength
