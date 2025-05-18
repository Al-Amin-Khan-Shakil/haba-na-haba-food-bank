module EventsHelper
    def joined_location_options(locations)
        locations.map do |loc|
          [
            [loc.district.name, loc.county.name, loc.sub_county.name].compact.join(', '),
            "location_#{loc.id}"
          ]
        end
    end
end
  