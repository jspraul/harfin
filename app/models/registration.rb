class Registration < ApplicationRecord

  RED = 'Red'
  BLUE = 'Blue'

  YOUNGER = '3-5s'
  OLDER = '1st-6th'

  belongs_to :person
  belongs_to :sessionyear

  validates :person_id, :sessionyear_id, presence: true
  validates :group_assignment, inclusion: {in: [YOUNGER, OLDER] }
  validates :team_name, inclusion: {in: [RED, BLUE] }

  def progress_stats
    return @progress_stats if @progress_stats.present?
    sy = self.sessionyear
    clubber = self.person
    signas_count = clubber.scores_in(sy).joins(:scoretype).
                                 where(scoretypes:{name:Scoretype::SIGNA_TYPES}).count
    atts_count = clubber.attendances_in(sy).count
    @progress_stats = {
      signas_count: signas_count,
      signas_per_attendance: signas_count.to_f / atts_count.to_f,
      pc_to_gold: signas_count.to_f / self.signas_awards[:Gold].to_f,
      pc_to_silver: signas_count.to_f / self.signas_awards[:Silver].to_f,
      signas_to_gold: self.signas_awards[:Gold] - signas_count,
      signas_to_silver: self.signas_awards[:Silver] - signas_count
    }
  end

  def signas_awards
    Scoretype::SIGNAS_AWARDS[self.group_assignment]
  end

  def self.for_person_in(person, sessionyear)
    person.registrations.where(sessionyear: sessionyear)
  end

end
