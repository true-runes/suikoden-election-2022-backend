class CheckVotesAndBonusesController < ApplicationController
  def index
    screen_name = Presenter::Common.normalized_screen_name(params[:screen_name])
    user = User.find_by(screen_name: screen_name)

    # TODO: エラーハンドリング
    return render json: {} if user.blank?

    gss2022_tweets = user.tweets.gensosenkyo_2022_votes_for_api
    unite_attacks_tweets = user.tweets.unite_attacks_votes_for_api
    short_stories = user.tweets.short_stories
    fav_quotes = user.tweets.fav_quotes
    sosenkyo_campaigns = user.tweets.sosenkyo_campaigns

    @gss2022_tweets = gss2022_tweets.map(&:id_number)
    @unite_attacks_tweets = unite_attacks_tweets.map(&:id_number)
    @short_stories = short_stories.map(&:id_number)
    @fav_quotes = fav_quotes.map(&:id_number)
    @sosenkyo_campaigns = sosenkyo_campaigns.map(&:id_number)
  end
end
