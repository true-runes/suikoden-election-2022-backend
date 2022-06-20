class EventBasicData
  def self.begin_datetime
    Time.zone.parse('2022-06-24 21:00:00')
  end

  def self.end_datetime
    Time.zone.parse('2022-06-26 23:59:59')
  end

  def used_hashtags
    [
      '#幻水総選挙2022',
      '#幻水総選挙2022協力攻撃',
      '#幻水総選挙運動',
      '#幻水総選挙お題小説',
      '#幻水総選挙推し台詞',
    ]
  end
end
