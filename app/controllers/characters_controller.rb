class CharactersController < ApplicationController
  def index
    nickname = params[:nickname]
    return render json: { nickname: '', products: '' } if nickname.blank?

    nickname.tr!("０-９", "0-9") # データベースに全角を持たせるべきかどうか
    nickname_instance = Nickname.find_by(name: nickname)
    return render json: { nickname: nickname, products: '' } if nickname_instance.blank?

    # TODO: 複数いた場合どうするか
    character = nickname_instance.characters.first
    return render json: { nickname: nickname, products: '' } if character.blank?

    products = character.products.pluck(:name)
    render json: { nickname: nickname, character: character.name, products: products }
  end
end
