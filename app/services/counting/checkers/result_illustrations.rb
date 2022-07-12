module Counting
  module Checkers
    class ResultIllustrations
      def initialize
        @excluded_character_names = Rails.application.credentials.excluded_not_in_db_character_names
      end

      def is_in_sheet_character_name_in_db?(in_sheet_character_name)
        return true if in_sheet_character_name.in?(@excluded_character_names)
        return true if Character.find_by(name: in_sheet_character_name).present?

        Presenter::ResultIllustrations.convert_character_name_in_sheet_to_character_name_in_db(in_sheet_character_name).present?
      end
    end
  end
end
