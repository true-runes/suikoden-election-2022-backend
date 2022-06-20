# rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/BlockLength
module Tweets
  module Importer
    class FromApiResponse
      class << self
        # おそらく使う機会がないと思われるので、前年のコピペをするのみにとどめている
        def tweet_records_from_api_tweet_objects(api_tweet_objects)
          ActiveRecord::Base.transaction do
            api_tweet_objects.each do |api_tweet|
              ###############
              # User
              ###############
              user_attrs = {
                id_number: api_tweet.user.id,
                name: api_tweet.user.name.instance_of?(Twitter::NullObject) ? 'Twitter::NullObject' : api_tweet.user.name,
                screen_name: api_tweet.user.screen_name,
                profile_image_url_https: api_tweet.user.profile_image_url_https.to_s,
                is_protected: false,
                born_at: api_tweet.user.created_at
              }

              user = User.find_by(id_number: user_attrs[:id_number])
              if user.blank?
                new_user = User.new(user_attrs)
                new_user.save!
              end

              ###############
              # Tweet
              ###############
              tweet_attrs = {
                id_number: api_tweet.id,
                full_text: api_tweet.full_text,
                source: api_tweet.source,
                in_reply_to_tweet_id_number: api_tweet.in_reply_to_status_id,
                in_reply_to_user_id_number: api_tweet.in_reply_to_user_id,
                is_retweet: api_tweet.retweet?,
                language: api_tweet.lang,
                is_public: true,
                tweeted_at: api_tweet.created_at,
                user: new_user || user
              }

              tweet = Tweet.find_by(id_number: tweet_attrs[:id_number])

              if tweet.blank?
                new_tweet = Tweet.new(tweet_attrs)
                new_tweet.save!
              else
                next
              end

              ###############
              # Asset
              ###############
              api_tweet.media.each do |asset|
                asset_attrs = {
                  id_number: asset.id,
                  url: asset.media_url_https,
                  asset_type: asset.type,
                  is_public: true,
                  tweet: new_tweet || tweet
                }

                asset = Asset.find_by(id_number: asset_attrs[:id_number])
                if asset.blank?
                  new_asset = Asset.new(asset_attrs)
                  new_asset.save!
                end
              end

              ###############
              # Hashtag
              ###############
              api_tweet.hashtags.each do |hashtag|
                hashtag_attrs = {
                  text: hashtag.text,
                  tweet: new_tweet || tweet
                }

                hashtag = Hashtag.find_by(
                  text: hashtag_attrs[:text],
                  tweet_id: (new_tweet || tweet).id
                )
                if hashtag.blank?
                  new_hashtag = Hashtag.new(hashtag_attrs)
                  new_hashtag.save!
                end
              end

              ###############
              # InTweetUrl
              ###############
              # ツイートの URL ではなく、ツイートに含まれている URL
              api_tweet.urls.each do |url|
                in_tweet_url_attrs = {
                  text: url.expanded_url.to_s,
                  tweet: new_tweet || tweet
                }

                in_tweet_url = InTweetUrl.find_by(
                  text: in_tweet_url_attrs[:text],
                  tweet_id: (new_tweet || tweet).id
                )
                if in_tweet_url.blank?
                  new_in_tweet_url = InTweetUrl.new(in_tweet_url_attrs)
                  new_in_tweet_url.save!
                end
              end

              ###############
              # Mention
              ###############
              api_tweet.user_mentions.each do |mention|
                mention_attrs = {
                  user_id_number: mention.id,
                  tweet: new_tweet || tweet
                }

                mention = Mention.find_by(
                  user_id_number: mention_attrs[:user_id_number],
                  tweet_id: (new_tweet || tweet).id
                )
                if mention.blank?
                  new_mention = Mention.new(mention_attrs)
                  new_mention.save!
                end
              end
            end
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/BlockLength
