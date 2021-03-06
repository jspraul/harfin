class Sessionyear < ApplicationRecord

  has_many :sessiondays
  has_many :registrations

  scope :sorted, -> { order('start_date desc') }

  validates_presence_of :start_date
  validates_presence_of :end_date

  #
  def self.current
    where(['start_date < ? and end_date > ?', Time.now, Time.now]).first
  end
  def self.current_or_next
    where(['end_date > ?', Time.now]).order('end_date ASC').first
  end

  def self.vals_for_select
    vals = []
    sorted.limit(5).each do |sy|
      vals << [sy.year_with_theme, sy.id]
    end
    return vals
  end

  def year
    "#{start_date.to_formatted_s(:year)}-#{end_date.to_formatted_s(:year)}"
  end

  def year_with_theme
    "#{year} #{theme}"
  end

  def has_cal?
    return sessiondays.count > 0
  end

  # Given a date, return the sessionday club night if exists
  def club_night_on(date)
    sessiondays.where(sd_date: date).club_nights.first
  end


end
