module FilterMethods
    private
  
    # General filters (first occurrences kept)
    
    def filter_by_name(model, name)
        name.present? ? model.where('name ILIKE ?', "%#{name}%") : model
    end
    def filter_by_title(model, title)
      title.present? ? model.where('title ILIKE ?', "%#{title}%") : model
    end
    def filter_by_description(model, description)
      description.present? ? model.where('Description ILIKE ?', "%#{title}%") : model
    end
  
    def filter_by_first_name(model, first_name)
      first_name.present? ? model.where('first_name ILIKE ?', "%#{first_name}%") : model
    end

    def filter_by_last_name(model, last_name)
      last_name.present? ? model.where('last_name ILIKE ?', "%#{last_name}%") : model
    end
    def filter_by_role(model, role)
      role.present? ? model.where(role: role) : model
    end
    

    def filter_by_phone_number(model, phone_number)
      return model unless phone_number.present?
    
      digits = phone_number.gsub(/\D/, '')
      model.where('REGEXP_REPLACE(phone_number, \'\\D\', \'\', \'g\') ILIKE ?', "%#{digits}%")
    end
    
    # Family beneficiary specific filters (non duplicated)
  
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
  
    def filter_by_date_range(model, start_date, end_date)
      # Parse dates (handle invalid formats gracefully)
      parsed_start = start_date.present? ? Date.parse(start_date) : nil
      parsed_end = end_date.present? ? Date.parse(end_date) : nil
    
      # Validate date range
      if parsed_start && parsed_end && parsed_end < parsed_start
        Rails.logger.warn "Invalid date range: end_date (#{parsed_end}) is before start_date (#{parsed_start}). Forcing end_date = today."
        parsed_end = Date.current
      end
    
      # Apply filters
      if parsed_start && parsed_end
        model.where(created_at: parsed_start..parsed_end)
      elsif parsed_start
        model.where('created_at >= ?', parsed_start)
      elsif parsed_end
        # Default start_date to beginning of year if only end_date is given
        model.where(created_at: Date.current.beginning_of_year..parsed_end)
      else
        model
      end
    rescue ArgumentError => e
      Rails.logger.error "Invalid date format: #{e.message}"
      model # Fallback to unfiltered query if date parsing fails
    end
    
    def filter_by_branch_id(model, branch_id)
      branch_id.present? ? model.where(branch_id: branch_id) : model
    end
  
    def filter_by_provided_food(model, provided_food)
      return model unless provided_food.present?
  
      if provided_food == 'provided'
        model.where('provided_food > 0')
      elsif provided_food == 'not_provided'
        model.where('provided_food <= 0 OR provided_food IS NULL')
      else
        model
      end
    end
  
    def filter_by_location(model, district_id, county_id, sub_county_id)
      model = model.where(district_id: district_id) if district_id.present?
      model = model.where(county_id: county_id) if county_id.present?
      model = model.where(sub_county_id: sub_county_id) if sub_county_id.present?
      model
    end
  
    # Additional unique filters for other contexts:
  
    def filter_by_gender(model, gender)
      if gender.present? && model.defined_enums['gender'].key?(gender)
      model.where(gender: model.genders[gender])
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
  
    def filter_by_request_type(model, request_types)
        if request_types.present?
          request_types = Array.wrap(request_types)
          enum_values = request_types.map { |type| Request.request_types[type] }.compact
          enum_values.any? ? model.where(request_type: enum_values) : model.none
        else
          model
        end
      end
      
  
    def filter_by_is_selected(model, is_selected)
      is_selected.present? ? model.where(is_selected: is_selected) : model
    end
  
    def filter_by_branch(model, branch_id)
      branch_id.present? ? model.where(branch_id: branch_id) : model
    end
  
    # Inventories filters:
  
    def filter_by_donation_type(model, donation_type)
      donation_type.present? ? model.where('donation_type ILIKE ?', "%#{donation_type}%") : model
    end
  
    def filter_by_donor_type(model, donor_type)
      donor_type.present? ? model.where('donor_type ILIKE ?', "%#{donor_type}%") : model
    end
  
    def filter_by_donor_name(model, donor_name)
      donor_name.present? ? model.where('donor_name ILIKE ?', "%#{donor_name}%") : model
    end
end
  