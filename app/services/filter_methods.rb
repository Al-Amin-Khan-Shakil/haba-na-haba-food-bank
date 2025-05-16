module FilterMethods
    private
  
    # General filters (first occurrences kept)
    
    def filter_by_name(relation, name)
        name.present? ? relation.where('name ILIKE ?', "%#{name}%") : relation
    end
  
    def filter_by_first_name(relation, first_name)
      first_name.present? ? relation.where('first_name ILIKE ?', "%#{first_name}%") : relation
    end

    def filter_by_last_name(relation, last_name)
      last_name.present? ? relation.where('last_name ILIKE ?', "%#{last_name}%") : relation
    end

    def filter_by_role(relation, role)
      role.present? ? relation.where('role ILIKE ?', "%#{role}%") : relation
    end

    def filter_by_phone_number(relation, phone_number)
      return relation unless phone_number.present?
    
      digits = phone_number.gsub(/\D/, '')
      relation.where('REGEXP_REPLACE(phone_number, \'\\D\', \'\', \'g\') ILIKE ?', "%#{digits}%")
    end
    
    # Family beneficiary specific filters (non duplicated)
  
    def filter_by_father_name(relation, fathers_name)
      fathers_name.present? ? relation.where('fathers_name ILIKE ?', "%#{fathers_name}%") : relation
    end
  
    def filter_by_mother_name(relation, mothers_name)
      mothers_name.present? ? relation.where('mothers_name ILIKE ?', "%#{mothers_name}%") : relation
    end
  
    def filter_by_case_name(relation, case_name)
      case_name.present? ? relation.where('case_name ILIKE ?', "%#{case_name}%") : relation
    end
  
    def filter_by_member_count(relation, min_member, max_member)
      if min_member.present? && max_member.present?
        relation.where(family_members: min_member..max_member)
      elsif min_member.present?
        relation.where('family_members >= ?', min_member)
      elsif max_member.present?
        relation.where('family_members <= ?', max_member)
      else
        relation
      end
    end
  
    def filter_by_date_range(relation, start_date, end_date)
      if start_date.present? && end_date.present?
        relation.where(created_at: Date.parse(start_date)..Date.parse(end_date))
      else
        relation
      end
    end
  
    def filter_by_branch_id(relation, branch_id)
      branch_id.present? ? relation.where(branch_id: branch_id) : relation
    end
  
    def filter_by_provided_food(relation, provided_food)
      return relation unless provided_food.present?
  
      if provided_food == 'provided'
        relation.where('provided_food > 0')
      elsif provided_food == 'not_provided'
        relation.where('provided_food <= 0 OR provided_food IS NULL')
      else
        relation
      end
    end
  
    def filter_by_location(relation, district_id, county_id, sub_county_id)
      relation = relation.where(district_id: district_id) if district_id.present?
      relation = relation.where(county_id: county_id) if county_id.present?
      relation = relation.where(sub_county_id: sub_county_id) if sub_county_id.present?
      relation
    end
  
    # Additional unique filters for other contexts:
  
    def filter_by_gender(relation, gender)
      gender.present? ? relation.where('gender = ?', gender) : relation
    end
  
    def filter_by_age(relation, min_age, max_age)
      if min_age.present? && max_age.present?
        relation.where(age: min_age..max_age)
      elsif min_age.present?
        relation.where('age >= ?', min_age)
      elsif max_age.present?
        relation.where('age <= ?', max_age)
      else
        relation
      end
    end
  
    def filter_by_organization_name(relation, organization_name)
      organization_name.present? ? relation.where('organization_name ILIKE ?', "%#{organization_name}%") : relation
    end
  
    def filter_by_registration_no(relation, registration_no)
      registration_no.present? ? relation.where('registration_no ILIKE ?', "%#{registration_no}%") : relation
    end
  
    def filter_by_people_count(relation, min_people, max_people)
      min_people = min_people.presence || 0
      max_people = max_people.presence || (min_people.to_i + 100)
      relation.where('(male + female) BETWEEN ? AND ?', min_people, max_people)
    end
  
    def filter_by_request_type(relation, request_types)
        if request_types.present?
          request_types = Array.wrap(request_types)
          enum_values = request_types.map { |type| Request.request_types[type] }.compact
          enum_values.any? ? relation.where(request_type: enum_values) : relation.none
        else
          relation
        end
      end
      
  
    def filter_by_is_selected(relation, is_selected)
      is_selected.present? ? relation.where(is_selected: is_selected) : relation
    end
  
    def filter_by_branch(relation, branch_id)
      branch_id.present? ? relation.where(branch_id: branch_id) : relation
    end
  
    # Inventories filters:
  
    def filter_by_donation_type(relation, donation_type)
      donation_type.present? ? relation.where('donation_type ILIKE ?', "%#{donation_type}%") : relation
    end
  
    def filter_by_donor_type(relation, donor_type)
      donor_type.present? ? relation.where('donor_type ILIKE ?', "%#{donor_type}%") : relation
    end
  
    def filter_by_donor_name(relation, donor_name)
      donor_name.present? ? relation.where('donor_name ILIKE ?', "%#{donor_name}%") : relation
    end
end
  