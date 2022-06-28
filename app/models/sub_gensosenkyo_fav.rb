class SubGensosenkyoFav < ApplicationRecord
  belongs_to :tweet, optional: true

  def url_as_screen_name_is_twitter
    "https://twitter.com/twitter/status/#{id_number}"
  end
end
