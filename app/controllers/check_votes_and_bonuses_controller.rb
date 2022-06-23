class CheckVotesAndBonusesController < ApplicationController
  def index
    @gss2022_tweets = []
    @unite_attacks_tweets = []
    @short_stories = []
    @fav_quotes = []
    @sosenkyo_campaigns = []

    @screen_name = Presenter::Common.normalized_screen_name(params[:screen_name])
    user = User.find_by(screen_name: @screen_name)

    if user.present?
      begin
        gss2022_tweets = user.tweets.gensosenkyo_2022_votes_for_api
        unite_attacks_tweets = user.tweets.unite_attacks_votes_for_api
        short_stories = user.tweets.short_stories_for_api
        fav_quotes = user.tweets.fav_quotes_for_api
        sosenkyo_campaigns = user.tweets.sosenkyo_campaigns_for_api

        # react-twitter-embed へ渡すためには文字列のほうが都合がいい
        @gss2022_tweets = gss2022_tweets.map { |t| t.id_number.to_s }
        @unite_attacks_tweets = unite_attacks_tweets.map { |t| t.id_number.to_s }
        @short_stories = short_stories.map { |t| t.id_number.to_s }
        @fav_quotes = fav_quotes.map { |t| t.id_number.to_s }
        @sosenkyo_campaigns = sosenkyo_campaigns.map { |t| t.id_number.to_s }
      rescue => e # rubocop:disable Style/RescueStandardError
        Rails.logger.error e.message
      end
    end

    append_omission_tweets(@screen_name)
  end

  private

  # 取得漏れ用
  # データベースに追加してしまうとスプレッドシートのデータに影響が出るため、APIロジック内だけで処理する
  # 配列の順番については考慮しない
  def append_omission_tweets(screen_name)
    return if screen_names_and_tweet_id_numbers.blank?

    target_screen_names = screen_names_and_tweet_id_numbers.keys

    if screen_name.in?(target_screen_names)
      @gss2022_tweets << screen_names_and_tweet_id_numbers[screen_name]['gss2022_tweets']
      @unite_attacks_tweets << screen_names_and_tweet_id_numbers[screen_name]['unite_attacks_tweets']
      @short_stories << screen_names_and_tweet_id_numbers[screen_name]['short_stories']
      @fav_quotes << screen_names_and_tweet_id_numbers[screen_name]['fav_quotes']
      @sosenkyo_campaigns << screen_names_and_tweet_id_numbers[screen_name]['sosenkyo_campaigns']

      [@gss2022_tweets, @unite_attacks_tweets, @short_stories, @fav_quotes, @sosenkyo_campaigns].each do |response|
        response.compact!
        response.flatten!
        response.uniq!
        response.map!(&:to_s)
      end
    end
  end

  def screen_names_and_tweet_id_numbers
    YAML.load_file(
      Rails.root.join('config/omission_tweets/screen_names_and_tweet_id_numbers.yml')
    )
  end
end
