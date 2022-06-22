# rubocop:disable Style/InfiniteLoop, Style/ConditionalAssignment

# ドキュメント
# https://developer.twitter.com/en/docs/twitter-api/v1/direct-messages/sending-and-receiving/api-reference/list-events
# https://www.rubydoc.info/gems/twitter/Twitter%2FREST%2FDirectMessages:direct_messages_events

module Dm
  class Importer
    INTERVAL_SECONDS = 10

    # 最新のものから過去のものに向かって取得していき、取得できなくなったら抜ける
    def self.exec(twitter_client: nil, number_of_getters: 1)
      twitter_client = TwitterRestApi.client(account_key: :gensosenkyo) if twitter_client.blank?

      next_cursor = nil
      loop_counter = 0

      while true
        # count は 1 にしておくのが望ましい（それでも28とか取ってきちゃうので）
        if next_cursor.nil?
          dm_events = twitter_client.direct_messages_events(count: 1)
        else
          dm_events = twitter_client.direct_messages_events(count: 1, cursor: next_cursor)
        end

        dm_events = dm_events.to_h
        next_cursor = dm_events[:next_cursor]
        events = dm_events[:events]

        ActiveRecord::Base.transaction do
          events.each do |event|
            dm = event[:direct_message]

            create_user_record(dm, twitter_client)
            create_direct_message_record(dm, event)

            sleep INTERVAL_SECONDS
          end
        end

        loop_counter += 1

        break if next_cursor.nil?
        break if loop_counter >= number_of_getters

        sleep INTERVAL_SECONDS * 5
      end

      "[DONE] Dm::Importer.exec"
    end

    def self.create_user_record(dm, twitter_client)
      sender_user_id_number = dm[:sender_id]
      recipient_user_id_number = dm[:recipient_id]

      [sender_user_id_number, recipient_user_id_number].each do |user_id_number|
        existing_user = User.find_by(id_number: user_id_number)

        if existing_user.blank?
          # Twitter API によりユーザー情報を取得する
          target_user = twitter_client.user(user_id_number)

          user = User.new(
            id_number: user_id_number,
            name: target_user.name,
            screen_name: target_user.screen_name,
            profile_image_url_https: target_user.profile_image_url_https.to_s,
            is_protected: target_user.protected?,
            born_at: target_user.created_at
          )

          user.save!
        end
      end

      "[DONE] self.create_user_record (sender_id: #{dm[:sender_id]} / recipient_id: #{dm[:recipient_id]})"
    end

    def self.create_direct_message_record(dm, event)
      direct_message = DirectMessage.new(
        id_number: dm[:id], # event[:id] に等しい
        messaged_at: dm[:created_at],
        text: dm[:text],
        sender_id_number: dm[:sender_id],
        recipient_id_number: dm[:recipient_id],
        is_visible: true,
        user_id: User.find_by(id_number: dm[:sender_id]).id,
        api_response: event
      )

      direct_message.save! if DirectMessage.find_by(id_number: dm[:id]).blank?

      "[DONE] self.create_direct_message_record (dm[:id]: #{dm[:id]})"
    end
  end
end
# rubocop:enable Style/InfiniteLoop, Style/ConditionalAssignment
