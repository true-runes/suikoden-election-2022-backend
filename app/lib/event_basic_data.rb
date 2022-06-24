class EventBasicData
  def self.begin_datetime
    Time.zone.parse('2022-06-24 21:00:00')
  end

  def self.end_datetime
    Time.zone.parse('2022-06-26 23:59:59')
  end

  def self.used_hashtags
    YAML.load_file(
      Rails.root.join('config/used_hashtags.yml')
    )['used_hashtags']
  end

  def self.sheet_names
    YAML.load_file(
      Rails.root.join('config/sheet_names.yml')
    )['sheet_names']
  end
end
