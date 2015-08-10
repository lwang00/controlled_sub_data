class Substance < ActiveRecord::Base
  acts_as_paranoid
  audited

  belongs_to :substance_classification
  has_many :substance_statutes
  has_many :substance_alternate_names

  validates_uniqueness_of :name
  validates_uniqueness_of :chemical_formula, allow_nil: true, allow_blank: true
  validates_uniqueness_of :chemical_formula_smiles_format, allow_nil: true, allow_blank: true

  def regulated_by_statutes(as_of_date = nil)
    statutes = substance_statutes.sort { |a,b| a.statute.start_date <=> b.statute.start_date }.map { |ss| ss.statute }
    statutes.select! { |s| s.start_date <= as_of_date } if as_of_date

    if statutes.any? { |s| s.state == 'REVAMPED_FEDERAL' }
      federally_scheduled_date = statutes.select { |s| s.state == 'REVAMPED_FEDERAL' }.first.start_date
      if as_of_date && as_of_date >= federally_scheduled_date
        federal_inheritors = Statute.where(['duplicate_federal_as_of_date <= ?', as_of_date]).all
      else
        federal_inheritors = Statute.where(['duplicate_federal_as_of_date IS NOT NULL']).all
      end
      statutes += federal_inheritors
    end
    statutes
  end

  def self.find_or_create_substance(name, options = {})
    s = nil
    name = name.strip
    s = Substance.where(name: name).first
    s = Substance.new(name: name) unless s

    if options[:classification]
      s.substance_classification_id = SubstanceClassification.find_or_create_substance_classification(options[:classification]).id
    end

    s.dea_code = options[:dea_code] if options[:dea_code]
    s.first_scheduled_date = options[:first_scheduled_date] if options[:first_scheduled_date]
    s.save

    s
  end
end
