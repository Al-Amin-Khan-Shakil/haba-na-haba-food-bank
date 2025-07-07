# Ensure required associations exist
branch = Branch.first
district = District.first
county = County.first
sub_county = SubCounty.first
user = User.first

if [branch, district, user].any?(&:nil?)
  puts "Please ensure Branch, District, County, SubCounty, and User records exist."
else
  start_date = Date.new(2025, 5, 31)
  end_date = Date.new(2025, 7, 17)

  (start_date..end_date).each do |date|
    rand(3..8).times do |i|
      Request.create!(
        name: "Request #{date}-#{i + 1}",
        phone_number: "070#{rand(1000000..9999999)}",
        request_type: rand(1..2),
        is_selected: [true, false].sample,
        village: "Village #{i + 1} on #{date}",
        parish: "Parish #{i + 1}",
        address_note: "Note for #{date}",
        branch_id: branch.id,
        district_id: district.id,
        county_id: county&.id,
        sub_county_id: sub_county&.id,
        user_id: user.id,
        created_at: date.to_time + rand(0..86400),  # random time during that day
        updated_at: date.to_time + rand(0..86400)
      )
    end
  end

  puts "✅ Seeded random number of requests per day from 21–27 May 2025."
end
