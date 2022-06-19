FactoryBot.define do
  factory :on_raw_sheet_result_illustration_totalling do
    character_name_by_sheet_totalling { (0...8).map{ (65 + rand(26)).chr }.join }
    number_of_applications { 123 }
    character_name_for_public { (0...8).map{ (65 + rand(26)).chr }.join }
  end
end
