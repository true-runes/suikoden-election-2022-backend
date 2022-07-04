class OnRawSheetResultIllustrationTotalling < ApplicationRecord
  # on_raw_sheet_result_illustration_totalling
  def convert_name_to_gensosenkyo_style(name)
    {
      "ほげ" => "ほげげげ"
    }[name] || name
  end
end

# irb(main):003:0> x = { a: 1, b: 2, c: 3 }
# irb(main):004:0> y = { a: 4, c: 5, d: 10 }
# irb(main):007:0> x.merge(y) { |_, oldval, newval| oldval + newval }
# => {:a=>5, :b=>2, :c=>8, :d=>10}
