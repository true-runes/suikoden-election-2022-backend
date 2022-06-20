class CheckVoteController < ApplicationController
  def index
    # TODO: @ の取り除き処理など
    screen_name = params[:screen_name] || 'gensosenkyo'

    # TODO: ハッシュタグ用のテーブルを作るのでそこから引っ張ってくる
    # user = User.find_by(screen_name: screen_name)
    # general_votes = user.general_votes
    # unite_attack_votes = user.unite_attack_votes
    # { general_votes: general_votes, unite_attack_votes: unite_attack_votes }
    # アソシエーション用の不要なカラムは返さなくていい
    # 返すのは、screen_name、tweet_id_number、（URL）あたり

    render json: { status: "This is a check vote API. Are you #{screen_name}?" }
  end
end
