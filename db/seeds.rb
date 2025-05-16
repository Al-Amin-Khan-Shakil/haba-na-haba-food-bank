# db/seeds.rb
FamilyBeneficiary.destroy_all
OrganizationBeneficiary.destroy_all
IndividualBeneficiary.destroy_all
Request.destroy_all
User.destroy_all
SubCounty.destroy_all
County.destroy_all
District.destroy_all
Branch.destroy_all




# Helper arrays for sample data
branch_names = ["Main Branch", "West Wing", "East End", "North Point", "South Base", "Central Hub"]
district_names = ["Central District", "North District", "South District", "East District", "West District", "Lake District"]
county_names = ["River County", "Hill County", "Forest County", "Valley County", "Desert County", "Bay County"]
sub_county_names = ["East Side", "West Side", "Uptown", "Downtown", "Midtown", "Old Town"]


# Create branches
branches = branch_names.map do |name|
  Branch.create!(
    name: name,
    phone_number: "123456#{rand(1000..9999)}",
    address: "#{name} Street, City"
  )
end

# Create districts
districts = district_names.each_with_index.map do |name, i|
  District.create!(
    name: name,
    branch: branches[i % branches.size]
  )
end

# Create counties
counties = county_names.each_with_index.map do |name, i|
  County.create!(
    name: name,
    district: districts[i % districts.size]
  )
end

# Create sub-counties
sub_counties = sub_county_names.each_with_index.map do |name, i|
  SubCounty.create!(
    name: name,
    county: counties[i % counties.size]
  )
end
ROLES = %w[super_admin admin branch_manager volunteer].freeze
GENDERS = %w[male female].freeze
# Create users
6.times do |i|
  User.create!(
    first_name: "User#{i + 1}",
    last_name: "Test",
    phone_number: "07000000#{i + 1}",
    role: ROLES[i % ROLES.size],
    gender: GENDERS[i % GENDERS.size],
    address: "Address #{i + 1}",
    email: "user#{i + 1}@example.com",
    password: "Password@#{i + 1}",
    password_confirmation: "Password@#{i + 1}"
  )
end

# Create an admin user
User.create!(
  first_name: "Admin",
  last_name: "User",
  phone_number: "0700000000",
  role: "admin",
  gender: "male",
  address: "Admin HQ",
  email: "admin@example.com",
  password: "StrongPassword@123",
  password_confirmation: "StrongPassword@123"
)

request_type = %w[food_request
  donation_request]

  users = User.all.to_a
  branches = Branch.all.to_a
  districts = District.all.to_a
  counties = County.all.to_a
  sub_counties = SubCounty.all.to_a

  6.times do |i|
    created_at_date =
    case i
    when 0, 1
      # Dates before this year
      Faker::Date.between(from: '2020-01-01', to: Date.new(Date.today.year - 1, 12, 31))
    when 2, 3
      # Dates between Jan and April this year
      Faker::Date.between(from: Date.new(Date.today.year, 1, 1), to: Date.new(Date.today.year, 4, 30))
    else
      # Dates from May this year to today
      Faker::Date.between(from: Date.new(Date.today.year, 5, 1), to: Date.today)
    end
    Request.create!(
      name: "Request #{i + 1}",
      phone_number: "07123456#{i}",
      request_type: request_type[i % request_type.size],
      is_selected: [true, false].sample,
      village: "Village #{i + 1}",
      parish: "Parish #{i + 1}",
      address_note: "Near the school, block #{i + 1}",
      branch: branches.sample,
      district: districts.sample,
      county: counties.sample,
      sub_county: sub_counties.sample,
      user: users.sample,
       created_at: created_at_date
    )
  end

  requests = Request.all.to_a
events = [] # Populate if you have events
families = []

10.times do |i|
  families << FamilyBeneficiary.create!(
    family_members: rand(2..10),
    male: rand(1..5),
    female: rand(1..5),
    children: rand(1..6),
    adult_age_range: "18-60",
    children_age_range: "2-17",
    district: districts.sample,
    county: counties.sample,
    sub_county: sub_counties.sample,
    address_note: "Near river bend, block #{i}",
    village: "Village #{('A'..'Z').to_a[i % 26]}",
    parish: "Parish #{rand(1..5)}",
    phone_number: "070#{rand(1000000..9999999)}",
    case_name: "Case #{i + 1}",
    case_description: "Family #{i + 1} is in need of food assistance due to recent hardships.",
    fathers_name: Faker::Name.male_first_name,
    mothers_name: Faker::Name.female_first_name,
    fathers_occupation: ["Farmer", "Driver", "Mason", "Fisherman"].sample,
    mothers_occupation: ["Tailor", "Vendor", "Teacher", "Nurse"].sample,
    number_of_meals_home: rand(1..3),
    number_of_meals_school: rand(0..2),
    basic_FEH: "Beans, Rice, Maize Flour",
    basic_FES: "Cooking Oil, Salt",
    provided_food: rand(10.0..50.0).round(2),
    request: requests.sample,
    event_id: events.sample&.id, # or remove this if you're not seeding events
    branch: branches.sample
  )
end

organizations = []

10.times do |i|
  organizations << OrganizationBeneficiary.create!(
    organization_name: "Organization #{i + 1}",
    male: rand(5..20),
    female: rand(5..20),
    adult_age_range: "18-60",
    children_age_range: "2-17",
    county: counties.sample,
    sub_county: sub_counties.sample,
    address_note: "Next to health center, block #{i}",
    village: "Village Org #{('A'..'Z').to_a[i % 26]}",
    parish: "Parish #{rand(1..5)}",
    phone_number: "075#{rand(1000000..9999999)}",
    case_name: "Org Case #{i + 1}",
    case_description: "Organization #{i + 1} requires supplies for its beneficiaries.",
    registration_no: "REG-ORG-#{1000 + i}",
    organization_no: "ORGNO-#{2000 + i}",
    directors_name: Faker::Name.name,
    head_of_institution: Faker::Name.name,
    number_of_meals_home: rand(1..3),
    basic_FEH: "Posho, Beans",
    provided_food: rand(20.0..100.0).round(2),
    event_id: events.sample&.id,
    district: districts.sample,
    branch: branches.sample,
    request: requests.sample
  )
end

individuals = []

10.times do |i|
  individuals << IndividualBeneficiary.create!(
    name: Faker::Name.name,
    age: rand(1..90),
    gender: GENDERS[i % GENDERS.size],
    phone_number: "079#{rand(1000000..9999999)}",
    case_name: "Indiv Case #{i + 1}",
    case_description: "Individual #{i + 1} needs urgent medical assistance.",
    father_name: Faker::Name.male_first_name,
    mother_name: Faker::Name.female_first_name,
    sur_name: Faker::Name.last_name,
    provided_food: rand(5.0..20.0).round(2),
    village: "Village Ind #{('A'..'Z').to_a[i % 26]}",
    parish: "Parish #{rand(1..5)}",
    address_note: "Behind the old church, block #{i}",
    district: districts.sample,
    county: counties.sample,
    sub_county: sub_counties.sample,
    request: requests.sample,
    branch: branches.sample,
    event_id: events.sample&.id
  )
end
