class SubGensosenkyoFav < ApplicationRecord
  belongs_to :tweet, optional: true

  def url_on_id_number
    "https://twitter.com/twitter/status/#{id_number}"
  end
end
