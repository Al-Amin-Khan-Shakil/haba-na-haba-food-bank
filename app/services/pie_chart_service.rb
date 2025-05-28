class PieChartService
  attr_reader :time_range, :start_date, :end_date, :individual_count, :family_count, :organization_count,
              :inventory_count, :percentages

  def initialize(time_range_param)
    @time_range = time_range_param&.to_sym || :last_7_days
    calculate_date_range
    fetch_counts
    calculate_percentages
  end

  private

  def calculate_date_range
    end_date = Date.today
    start_date = case time_range
                 when :today
                   end_date
                 when :yesterday
                   end_date = 1.day.ago.to_date
                   end_date
                 when :last_7_days
                   7.days.ago.to_date
                 when :last_30_days
                   30.days.ago.to_date
                 when :last_90_days
                   90.days.ago.to_date
                 when :current_year
                   Date.new(end_date.year, 1, 1)
                 else
                   Rails.logger.warn "Unrecognized time_range: #{@time_range}, defaulting to last 7 days"
                   7.days.ago.to_date
                 end
    @start_date = start_date
    @end_date = end_date
  end

  def fetch_counts
    range = start_date.beginning_of_day..end_date.end_of_day
    @individual_count = IndividualBeneficiary.where(created_at: range).count
    @family_count = FamilyBeneficiary.where(created_at: range).count
    @organization_count = OrganizationBeneficiary.where(created_at: range).count
    @inventory_count = Inventory.where(created_at: range).count
  end

  def calculate_percentages
    total = [individual_count, family_count, organization_count, inventory_count].sum.to_f
    total = 1 if total.zero?
    @percentages = [
      (individual_count / total * 100).round(1),
      (family_count / total * 100).round(1),
      (organization_count / total * 100).round(1),
      (inventory_count / total * 100).round(1)
    ]
  end
end
