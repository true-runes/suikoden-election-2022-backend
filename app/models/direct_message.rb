class DirectMessage < ApplicationRecord
  has_paper_trail

  serialize :api_response, JSON
  belongs_to :user
  has_one :analyze_syntax

  validates :id_number, uniqueness: true

  def self.for_spreadsheet
    to_gensosenkyo
      .order(messaged_at: :asc)
      .order(id_number: :asc)
  end

  # self.user と同義
  def sender
    User.find_by(id_number: sender_id_number)
  end

  def recipient
    User.find_by(id_number: recipient_id_number)
  end

  def self.valid_term_votes
    begin_datetime = EventBasicData.begin_datetime
    end_datetime = EventBasicData.end_datetime

    where(messaged_at: begin_datetime..end_datetime)
  end

  # gensosenkyo: 1471724029,
  # sub_gensosenkyo: 1388758231825018881
  def self.from_gensosenkyo
    where(sender_id_number: 1471724029)
  end

  def self.to_gensosenkyo
    where(recipient_id_number: 1471724029)
  end

  # NaturalLanguage::Analyzer 用
  def content_text
    text
  end
end
