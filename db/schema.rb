# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_06_24_052322) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "analyze_syntaxes", force: :cascade do |t|
    t.string "language"
    t.text "sentences", array: true
    t.text "tokens", array: true
    t.bigint "tweet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "direct_message_id"
    t.index ["direct_message_id"], name: "index_analyze_syntaxes_on_direct_message_id"
    t.index ["tweet_id"], name: "index_analyze_syntaxes_on_tweet_id"
  end

  create_table "assets", force: :cascade do |t|
    t.bigint "id_number"
    t.string "url"
    t.string "asset_type"
    t.boolean "is_public"
    t.bigint "tweet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tweet_id"], name: "index_assets_on_tweet_id"
  end

  create_table "character_nicknames", force: :cascade do |t|
    t.bigint "character_id"
    t.bigint "nickname_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_character_nicknames_on_character_id"
    t.index ["nickname_id"], name: "index_character_nicknames_on_nickname_id"
  end

  create_table "character_products", force: :cascade do |t|
    t.bigint "character_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_character_products_on_character_id"
    t.index ["product_id"], name: "index_character_products_on_product_id"
  end

  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.string "name_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "direct_messages", force: :cascade do |t|
    t.bigint "id_number"
    t.datetime "messaged_at", precision: nil
    t.string "text"
    t.bigint "sender_id_number"
    t.bigint "recipient_id_number"
    t.boolean "is_visible"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "api_response"
    t.index ["id_number"], name: "index_direct_messages_on_id_number", unique: true
    t.index ["user_id"], name: "index_direct_messages_on_user_id"
  end

  create_table "hashtags", force: :cascade do |t|
    t.string "text"
    t.bigint "tweet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tweet_id", "text"], name: "index_hashtags_on_tweet_id_and_text", unique: true
    t.index ["tweet_id"], name: "index_hashtags_on_tweet_id"
  end

  create_table "in_tweet_urls", force: :cascade do |t|
    t.string "text"
    t.bigint "tweet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tweet_id", "text"], name: "index_in_tweet_urls_on_tweet_id_and_text", unique: true
    t.index ["tweet_id"], name: "index_in_tweet_urls_on_tweet_id"
  end

  create_table "mentions", force: :cascade do |t|
    t.bigint "user_id_number"
    t.bigint "tweet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tweet_id", "user_id_number"], name: "index_mentions_on_tweet_id_and_user_id_number", unique: true
    t.index ["tweet_id"], name: "index_mentions_on_tweet_id"
  end

  create_table "nicknames", force: :cascade do |t|
    t.string "name", comment: "別名やプレイヤー間での呼称（日本語）"
    t.string "name_en", comment: "別名やプレイヤー間での呼称（英語）"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "on_raw_sheet_result_illustration_statuses", force: :cascade do |t|
    t.integer "id_on_sheet", null: false
    t.string "character_name", null: false
    t.string "name", null: false
    t.string "screen_name", null: false
    t.string "join_sosenkyo_book"
    t.string "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id_on_sheet"], name: "id_on_sheet_index", unique: true
  end

  create_table "on_raw_sheet_result_illustration_totallings", force: :cascade do |t|
    t.string "character_name_by_sheet_totalling", comment: "自動集計列のキャラ名"
    t.integer "number_of_applications", comment: "応募数"
    t.string "character_name_for_public", comment: "Webサイトに公開するキャラ名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_name_by_sheet_totalling"], name: "c_name_by_sheet_totalling_index", unique: true
    t.index ["character_name_for_public"], name: "c_name_for_public_index"
  end

  create_table "on_raw_sheet_unite_attacks", force: :cascade do |t|
    t.string "sheet_name", null: false
    t.string "name", null: false
    t.string "kana"
    t.string "name_en"
    t.string "chara_1"
    t.string "chara_2"
    t.string "chara_3"
    t.string "chara_4"
    t.string "chara_5"
    t.string "chara_6"
    t.string "page_annotation"
    t.string "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "name_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_products_on_name", unique: true
    t.index ["name_en"], name: "index_products_on_name_en", unique: true
  end

  create_table "realtime_reports", force: :cascade do |t|
    t.string "target_name", null: false
    t.string "date"
    t.string "hour"
    t.integer "vote_count"
    t.integer "vote_lang_count_ja"
    t.integer "vote_lang_count_others"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tweets", force: :cascade do |t|
    t.bigint "id_number", null: false
    t.string "full_text"
    t.string "source"
    t.bigint "in_reply_to_tweet_id_number"
    t.bigint "in_reply_to_user_id_number"
    t.boolean "is_retweet"
    t.string "language"
    t.boolean "is_public"
    t.datetime "tweeted_at", precision: nil
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id_number"], name: "index_tweets_on_id_number", unique: true
    t.index ["user_id"], name: "index_tweets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "id_number", null: false
    t.string "name", null: false
    t.string "screen_name", null: false
    t.string "profile_image_url_https"
    t.boolean "is_protected"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "born_at", precision: nil
    t.index ["id_number"], name: "index_users_on_id_number", unique: true
    t.index ["name"], name: "index_users_on_name"
    t.index ["screen_name"], name: "index_users_on_screen_name"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type"
    t.string "{:null=>false}"
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "character_nicknames", "characters"
  add_foreign_key "character_nicknames", "nicknames"
  add_foreign_key "character_products", "characters"
  add_foreign_key "character_products", "products"
end
