namespace :postal_code do
  desc "Generating fake postal codes"
  # rake postal_code:create_fake

  task create_fake: :environment do |task, args|
    countries = [
      { country_code: "PT", country_name: "Portugal" },
      { country_code: "ES", country_name: "Espanha" },
      { country_code: "IE", country_name: "Irlanda" },
      { country_code: "IT", country_name: "Itália" },
      { country_code: "FR", country_name: "França" },
      { country_code: "AL", country_name: "Alemanha" }
    ]

    10.times do
      # Generating PostalCode baths to mass registration

      postal_codes = Array.new

      10.times do
        # generating fake PostalCode
        postal_code = Faker::Address.full_address_as_hash(
          :street_name,
          :building_number,
          :city,
          :state,
          :secondary_address,
          :community,
          :mail_box,
          :latitude,
          :longitude
        )

        # Randomizing postal_code
        postal_codes_options = [
          "#{rand(1000..9999)}-#{rand(100..999)}",
          postal_code[:mail_box]
        ]

        postal_code[:postcode] = postal_codes_options[rand(0..1)]

        # creatring a similar postal_code to each country
        countries.each do |country|
          country_code = country[:country_code]
          country_name = country[:country_name]

          postal_codes << {
            country_code: country_code,
            postal_code: postal_code[:postcode].tr("^A-Za-z0-9", ""),
            metadata: {
              country_code: country_code,
              postal_code: postal_code[:postcode],
            },
            address: {
              label: "%{street_name}, %{building_number}, %{secondary_address}, %{city}, %{community}, %{state}, Portugal, %{postcode}" % postal_code,
              street: postal_code[:street_name],
              number: postal_code[:building_number],
              complement: postal_code[:secondary_address],
              area_lvl_1: { name: postal_code[:city] },
              area_lvl_2: { name: postal_code[:community] },
              area_lvl_3: { name: postal_code[:state] },
              area_lvl_4: nil,
              area_lvl_5: nil,
              area_lvl_6: nil,
              area_lvl_7: nil,
              postal_code: postal_code[:postcode],
              country: country_name,
              country_code: country_code
            },
            geodata: {
              coordinate: {
                lat: postal_code[:latitude],
                long: postal_code[:longitude]
              }
            }
          }
        end # countries
      end

      PostalCode.insert_all(postal_codes)

      puts "Postal Codes inserted: #{postal_codes.size}"
      puts "Total Postal Codes: #{PostalCode.all.count}"
    end
  end
end
