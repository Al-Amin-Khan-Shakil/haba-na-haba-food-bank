module RequestFilterMethods
  private

  def filter_by_request_type(model, request_type)
    request_type.present? ? model.where(request_type: request_type) : model
  end

  def filter_by_is_selected(model, is_selected)
    is_selected.present? ? model.where(is_selected: is_selected) : model
  end

  def filter_by_donor_type(model, donor_type)
    return model unless donor_type.present?

    model.joins(:donation).where(donations: { donor_type: donor_type })
  end

  def filter_by_expire_date(model, expire_date)
    return model unless expire_date.present?

    parsed_expire_date = begin
      Date.parse(expire_date.to_s)
    rescue StandardError
      nil
    end
    return model unless parsed_expire_date

    model.where(expire_date: Date.current.beginning_of_day..parsed_expire_date.end_of_day)
  end

  def filter_by_donation_type(model, donation_type)
    return model unless donation_type.present?

    model.joins(:donation).where(donations: { donation_type: donation_type })
  end

  def filter_by_donor_name(model, donor_name)
    return model unless donor_name.present?

    model.where('donor_name ILIKE ?', "%#{donor_name}%")
  end

  def filter_by_amount(model, amount)
    amount.present? ? model.where('amount <= ?', amount) : model
  end

  def filter_by_event_id(model, event_id)
    event_id.present? ? model.where(event_id: event_id) : model
  end

  def filter_start_date(model, start_date)
    start_date.present? ? model.where(start_date: start_date) : model
  end

  def filter_end_date(model, end_date)
    end_date.present? ? model.where(end_date: end_date) : model
  end
end
