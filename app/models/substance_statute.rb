class SubstanceStatute < ActiveRecord::Base
  acts_as_paranoid
  audited

  belongs_to :substance
  belongs_to :statute
  has_many :substance_alternate_names

  scope :additions, -> { where(is_expiration: false) }
  scope :expirations, -> { where(is_expiration: true) }

  DIFFERENT_SUBSTANCES = 'Different substances'
  DIFFERENT_SALTS = 'Different salt/isomer flags'
  DIFFERENT_SCHEDULE = 'Different schedule levels'

  def expiring_amendment(as_of_date = nil)
    expiring_substance_statute(as_of_date).try(:statute)
  end

  def expiring_substance_statute(as_of_date = nil)
    return nil if is_expiration

    base_statute = (statute.statute rescue nil) || statute
    expiring_statutes = SubstanceStatute.joins(:statute).where(
      substance_id: substance.id,
      statute_id: base_statute.statute_amendments.map { |a| a.id }
    ).where(['statutes.start_date > ?', statute.start_date]).expirations

    if as_of_date
      expiring_statutes = expiring_statutes.where(['start_date <= ?', as_of_date])
    end

    expiring_statutes.first
  end

  def expiration_date
    expiring_amendment.try(:start_date)
  end

  def include_flags_string
    include_flags.map { |f| f.sub(/^include_/, '').humanize }.join(', ')
  end

  def has_include_flags?
    include_flags.size > 0
  end

  def regulates_same_as?(substance_statute)
    regulation_differences(substance_statute).empty?
  end

  # Comparison method
  def regulation_differences(substance_statute)
    differences = []
    if substance_id != substance_statute.substance_id
      differences << DIFFERENT_SUBSTANCES
    else
      differences << DIFFERENT_SALTS unless include_flags.sort == substance_statute.include_flags.sort
      differences << DIFFERENT_SCHEDULE unless schedule_level == substance_statute.schedule_level
    end

    differences
  end

  protected

  def include_flags
    self.attributes.select { |k,v| k =~ /^include_/ && v == true }.keys
  end
end
