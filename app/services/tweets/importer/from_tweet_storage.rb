module Tweets
  module Importer
    class FromTweetStorage
      class << self
        # tweets には TweetOnTweetStorage のオブジェクトが渡される
        def exec(tweets: nil)
          return if tweets.blank?

          ActiveRecord::Base.transaction do
            tweets.each do |tweet|
              import_user_record(tweet)
              import_tweet_record(tweet)

              next if @imported_tweet.blank?

              import_asset_record(tweet)
              import_hashtag_record(tweet)
              import_in_tweet_url_record(tweet)
              import_mention_record(tweet)
            end
          end
        end

        def import_user_record(tweet)
          user_attrs = {
            id_number: tweet.user.id_number,
            name: tweet.user.name,
            screen_name: tweet.user.screen_name,
            profile_image_url_https: tweet.user.deserialize.profile_image_url_https.to_s,
            is_protected: false,
            born_at: tweet.user.created_at
          }

          # User はプロフ関連の情報や鍵情報の更新があり得るが、ここでは新規のみ扱う
          existing_user = User.find_by(id_number: user_attrs[:id_number])

          if existing_user.blank?
            @imported_user = User.new(user_attrs)

            @imported_user.save!
          else
            @imported_user = existing_user
          end
        end

        def import_tweet_record(tweet)
          tweet_attrs = {
            id_number: tweet.id_number,
            full_text: tweet.full_text,
            source: tweet.source,
            in_reply_to_tweet_id_number: tweet.deserialize.in_reply_to_tweet_id,
            in_reply_to_user_id_number: tweet.deserialize.in_reply_to_user_id,
            is_retweet: tweet.retweet?,
            language: tweet.lang,
            is_public: true,
            tweeted_at: tweet.tweeted_at,
            user: @imported_user
          }

          existing_tweet = Tweet.find_by(id_number: tweet_attrs[:id_number])

          if existing_tweet.blank?
            @imported_tweet = Tweet.new(tweet_attrs)

            @imported_tweet.save!
          else
            @imported_tweet = false
            # @imported_tweet = existing_tweet
          end
        end

        def import_asset_record(tweet)
          tweet.deserialize.media.each do |asset|
            asset_attrs = {
              id_number: asset.id,
              url: asset.media_url_https,
              asset_type: asset.type,
              is_public: true,
              tweet: @imported_tweet
            }

            Asset.new(asset_attrs).save! if Asset.find_by(id_number: asset_attrs[:id_number]).blank?
          end
        end

        def import_hashtag_record(tweet)
          tweet.deserialize.hashtags.each do |hashtag|
            hashtag_attrs = {
              text: hashtag.text,
              tweet: @imported_tweet
            }

            hashtag = Hashtag.find_by(
              text: hashtag_attrs[:text],
              tweet_id: @imported_tweet.id
            )

            Hashtag.new(hashtag_attrs).save! if hashtag.blank?
          end
        end

        def import_in_tweet_url_record(tweet)
          # ツイートに含まれている URL 文字列
          tweet.deserialize.urls.each do |url|
            in_tweet_url_attrs = {
              text: url.expanded_url.to_s,
              tweet: @imported_tweet
            }

            in_tweet_url = InTweetUrl.find_by(
              text: in_tweet_url_attrs[:text],
              tweet_id: @imported_tweet.id
            )

            InTweetUrl.new(in_tweet_url_attrs).save! if in_tweet_url.blank?
          end
        end

        def import_mention_record(tweet)
          tweet.deserialize.user_mentions.each do |mention|
            mention_attrs = {
              user_id_number: mention.id,
              tweet: @imported_tweet
            }

            mention = Mention.find_by(
              user_id_number: mention_attrs[:user_id_number],
              tweet_id: @imported_tweet.id
            )

            Mention.new(mention_attrs).save! if mention.blank?
          end
        end
      end
    end
  end
end
