class UssdHandler
  def initialize(params)
    @session_id = params[:sessionId]
    @phone_number = params[:phoneNumber]
    @text = params[:text].to_s.strip
    @input = @text.split('*')
  end

  # rubocop:disable Metrics/CyclomaticComplexity

  def handle
    case @input.length
    when 1 then prompt_for_name
    when 2 then prompt_for_request_type
    when 3 then handle_request_step_three
    when 4 then handle_request_step_four
    when 5 then handle_request_step_five
    when 6 then handle_request_step_six
    when 7 then handle_request_step_seven
    else 'END Invalid input. Please try again.'
    end
  end

  # rubocop:enable Metrics/CyclomaticComplexity

  private

  def prompt_for_name
    "CON Welcome to Haba Na Haba! \n Please enter your name:"
  end

  def prompt_for_request_type
    "CON What do you need?\n1. I need food\n2. I want to donate"
  end

  def handle_request_step_three
    if food_request?
      'CON Enter your district name:'
    elsif donation_request?
      "CON What do you want to donate?\n1. Fresh Food\n2. Dry Food\n3. Clothes\n4. Money\n5. Medicine\n6. Other"
    else
      'END Invalid input. Please try again.'
    end
  end

  def handle_request_step_four
    if food_request?
      'CON Enter your county name:'
    elsif donation_request?
      'CON Enter your district name:'
    else
      'END Invalid input. Please try again.'
    end
  end

  def handle_request_step_five
    if food_request?
      'CON Enter your sub-county name:'
    elsif donation_request?
      'CON Enter your county name:'
    else
      'END Invalid input. Please try again.'
    end
  end

  def handle_request_step_six
    if food_request?
      "END #{create_food_requesst}"
    elsif donation_request?
      'CON Enter your sub-county name:'
    else
      'END Invalid input. Please try again.'
    end
  end

  def handle_request_step_seven
    "END #{create_food_and_donation_request}"
  end

  def food_request?
    @input[2] == '1'
  end

  def donation_request?
    @input[2] == '2'
  end

  def create_food_requesst
    name = @input[1].titleize
    district = find_district(@input[3])
    county = find_county(@input[4], district)
    sub_county = find_sub_county(@input[5], county)

    Request.create!(
      name: name,
      phone_number: @phone_number,
      request_type: :food_request,
      district_id: district.id,
      county_id: county.id,
      sub_county_id: sub_county.id,
      branch_id: district.branch_id
    )
    'Success! We will contact you as soon as possible.'
  end

  def create_food_and_donation_request
    name = @input[1].titleize
    donation_type = @input[3].to_i
    district = find_district(@input[4])
    county = find_county(@input[5], district)
    sub_county = find_sub_county(@input[6], county)

    request = Request.create!(
      name: name,
      phone_number: @phone_number,
      request_type: :donation_request,
      district_id: district.id,
      county_id: county.id,
      sub_county_id: sub_county.id,
      branch_id: district.branch_id
    )

    request.create_donation!(donation_type: donation_type)
    'Success! We will contact you as soon as possible.'
  end

  def find_district(name)
    quoted_name = ActiveRecord::Base.connection.quote(name)
    District.where('similarity(name, ?) > 0.4', name)
      .order(Arel.sql("similarity(name, #{quoted_name}) DESC"))
      .first
  end

  def find_county(name, district)
    return nil unless district

    quoted_name = ActiveRecord::Base.connection.quote(name)
    district.counties.where('similarity(name, ?) > 0.4', name)
      .order(Arel.sql("similarity(name, #{quoted_name}) DESC"))
      .first
  end

  def find_sub_county(name, county)
    return nil unless county

    quoted_name = ActiveRecord::Base.connection.quote(name)
    county.sub_counties.where('similarity(name, ?) > 0.4', name)
      .order(Arel.sql("similarity(name, #{quoted_name}) DESC"))
      .first
  end
end
