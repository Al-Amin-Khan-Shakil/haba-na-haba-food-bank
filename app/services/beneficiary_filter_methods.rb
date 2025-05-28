module BeneficiaryFilterMethods
  private

  # Request Filters
  def filter_by_request_type(model, request_type)
    request_type.present? ? model.where(request_type: request_type) : model
  end

  def filter_by_is_selected(model, is_selected)
    is_selected.present? ? model.where(is_selected: is_selected) : model
  end

  # Inventories Filters
  def filter_by_donor_type(model, donor_type)
    return model unless donor_type.present?
    model.joins(:donation).where(donations: { donor_type: donor_type })
  end

  def filter_by_expire_date(model, expire_date)
    expire_date.present? ? model.where(expire_date: expire_date) : model
  end

  def filter_by_donation_type(model, donation_type)
    return model unless donation_type.present?
    model.joins(:donation).where(donations: { donation_type: donation_type })
  end

  def filter_by_donor_name(model, donor_name)
    donor_name.present? ? model.where('donor_name ILIKE ?', "%#{donor_name}%") : model
  end

  def filter_by_amount(model, amount)
    amount.present? ? model.where(amount: amount) : model
  end

  def filter_by_event_id(model, event_id)
    event_id.present? ? model.where(event_id: event_id) : model
  end

  # Events filter 
  def filter_start_date(model, start_date)
    start_date.present? ? model.where(start_date: start_date) : model
  end

  def filter_end_date(model, end_date)
    end_date.present? ? model.where(end_date: end_date) : model
  end

  # Common beneficiary filters
  def filter_by_first_name(model, first_name)
    first_name.present? ? model.where('first_name ILIKE ?', "%#{first_name}%") : model
  end

  def filter_by_last_name(model, last_name)
    last_name.present? ? model.where('last_name ILIKE ?', "%#{last_name}%") : model
  end

  def filter_by_name(model, name)
    name.present? ? model.where('name ILIKE ?', "%#{name}%") : model
  end

  ROLES = %w[super_admin admin branch_manager volunteer].freeze

  def filter_by_role(model, role)
    if role.present? && ROLES.include?(role)
      model.where(role: role)
    else
      model
    end
  end

  def filter_by_age(model, min_age, max_age)
    if min_age.present? && max_age.present?
      model.where(age: min_age..max_age)
    elsif min_age.present?
      model.where('age >= ?', min_age)
    elsif max_age.present?
      model.where('age <= ?', max_age)
    else
      model
    end
  end

  def filter_by_phone_number(model, phone_number)
    return model unless phone_number.present?

    digits = phone_number.gsub(/\D/, '')
    model.where("REGEXP_REPLACE(phone_number, '\\D', '', 'g') ILIKE ?", "%#{digits}%")
  end

  def filter_by_location(model, district_id, county_id, sub_county_id)
    model = model.where(district_id: district_id) if district_id.present?
    model = model.where(county_id: county_id) if county_id.present?
    model = model.where(sub_county_id: sub_county_id) if sub_county_id.present?
    model
  end

  # FamilyBeneficiary-specific
  def filter_by_fathers_name(model, fathers_name)
    fathers_name.present? ? model.where('fathers_name ILIKE ?', "%#{fathers_name}%") : model
  end

  def filter_by_mothers_name(model, mothers_name)
    mothers_name.present? ? model.where('mothers_name ILIKE ?', "%#{mothers_name}%") : model
  end

  def filter_by_case_name(model, case_name)
    case_name.present? ? model.where('case_name ILIKE ?', "%#{case_name}%") : model
  end

  def filter_by_member_count(model, min_member, max_member)
    if min_member.present? && max_member.present?
      model.where(family_members: min_member..max_member)
    elsif min_member.present?
      model.where('family_members >= ?', min_member)
    elsif max_member.present?
      model.where('family_members <= ?', max_member)
    else
      model
    end
  end

  def filter_by_branch_id(model, branch_id)
    branch_id.present? ? model.where(branch_id: branch_id) : model
  end

  def filter_by_provided_food(model, provided_food)
    provided_food.present? ? model.where(provided_food: provided_food) : model
  end

  # OrganizationBeneficiary-specific
  def filter_by_organization_name(model, organization_name)
    organization_name.present? ? model.where('organization_name ILIKE ?', "%#{organization_name}%") : model
  end

  def filter_by_registration_no(model, registration_no)
    registration_no.present? ? model.where('registration_no ILIKE ?', "%#{registration_no}%") : model
  end

  def filter_by_people_count(model, min_people, max_people)
    min_people = min_people.presence || 0
    max_people = max_people.presence || (min_people.to_i + 100)
    model.where('(male + female) BETWEEN ? AND ?', min_people, max_people)
  end
end