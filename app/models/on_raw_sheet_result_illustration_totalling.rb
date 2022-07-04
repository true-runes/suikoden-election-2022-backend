class OnRawSheetResultIllustrationTotalling < ApplicationRecord
  def self.not_exists_character_names_in_db
    on_sheet_character_names = OnRawSheetResultIllustrationTotalling.pluck(:character_name_for_public)
    on_db_character_names = Character.pluck(:name)

    not_exists_character_names_in_db = []

    on_sheet_character_names.each do |character_name|
      not_exists_character_names_in_db << character_name unless character_name.in?(on_db_character_names)
    end

    not_exists_character_names_in_db
  end
end
