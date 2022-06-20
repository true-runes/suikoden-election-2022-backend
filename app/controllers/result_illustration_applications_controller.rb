class ResultIllustrationApplicationsController < ApplicationController
  def index
    @application_character_names = OnRawSheetResultIllustrationTotalling.order(character_name_for_public: :asc).pluck(:character_name_for_public)
  end
end
