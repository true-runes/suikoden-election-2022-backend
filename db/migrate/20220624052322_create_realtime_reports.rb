class CreateRealtimeReports < ActiveRecord::Migration[7.0]
  def change
    create_table :realtime_reports do |t|
      t.string :target_name, null: false
      t.string :date
      t.string :hour
      t.integer :vote_count
      t.integer :vote_lang_count_ja
      t.integer :vote_lang_count_others

      t.timestamps
    end
  end
end
