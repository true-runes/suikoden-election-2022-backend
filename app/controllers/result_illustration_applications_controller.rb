class ResultIllustrationApplicationsController < ApplicationController
  def index
    @application_character_names = OnRawSheetResultIllustrationTotalling.order(character_name_for_public: :asc).pluck(:character_name_for_public).reject { |name| name.start_with?('TEMP_') }

    # まずはざっくりでいいので created_at を取る
    last_created_at = OnRawSheetResultIllustrationTotalling.first.created_at

    last_updated_at_date = Presenter::Common.japanese_date_strftime(last_created_at, with_day_of_the_week: true)
    last_updated_at_time = Presenter::Common.japanese_clock_time_strftime(last_created_at, with_seconds: false)

    @last_updated_at = "#{last_updated_at_date}#{last_updated_at_time}"
  end
end
