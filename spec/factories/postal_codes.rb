FactoryBot.define do
  ########
  ### LANGUAGE  PT
  #######
  #
  factory :default_postal_code_pt_pt, class: PostalCode do
    language_code { "PT" }
    country_code { "PT" }
    postal_code { "0000000" }
    metadata {
      {
        language_code: "PT",
        country_code: "PT",
        postal_code: "0000-000"
      }
    }
    address { "address" }
    geodata { "geodata" }
  end

  factory :default_postal_code_pt_it, class: PostalCode do
    language_code { "PT" }
    country_code { "IT" }
    postal_code { "0000000" }
    metadata {
      {
        language_code: "PT",
        country_code: "IT",
        postal_code: "0000-000"
      }
    }
    address { "address" }
    geodata { "geodata" }
  end

  factory :default_postal_code_pt_es, class: PostalCode do
    language_code { "PT" }
    country_code { "ES" }
    postal_code { "0000000" }
    metadata {
      {
        language_code: "PT",
        country_code: "ES",
        postal_code: "0000-000"
      }
    }
    address { "address" }
    geodata { "geodata" }
  end

  ########
  ### LANGUAGE  ES
  #######

  factory :default_postal_code_es_pt, class: PostalCode do
    language_code { "ES" }
    country_code { "PT" }
    postal_code { "0000000" }
    metadata {
      {
        language_code: "ES",
        country_code: "PT",
        postal_code: "0000-000"
      }
    }
    address { "address" }
    geodata { "geodata" }
  end

  factory :default_postal_code_es_es, class: PostalCode do
    language_code { "ES" }
    country_code { "ES" }
    postal_code { "0000000" }
    metadata {
      {
        language_code: "ES",
        country_code: "ES",
        postal_code: "0000-000"
      }
    }
    address { "address" }
    geodata { "geodata" }
  end

  factory :default_postal_code_es_it, class: PostalCode do
    language_code { "ES" }
    country_code { "IT" }
    postal_code { "0000000" }
    metadata {
      {
        language_code: "ES",
        country_code: "IT",
        postal_code: "0000-000"
      }
    }
    address { "address" }
    geodata { "geodata" }
  end

  ########
  ### LANGUAGE  IT
  #######

  factory :default_postal_code_it_it, class: PostalCode do
    language_code { "IT" }
    country_code { "IT" }
    postal_code { "0000000" }
    metadata {
      {
        language_code: "IT",
        country_code: "IT",
        postal_code: "0000-000"
      }
    }
    address { "address" }
    geodata { "geodata" }
  end

  ########
  ### RANDOM
  #######

  factory :random_postal_code_pt, class: PostalCode do
    postal_code = generate_random_postal_code_hash

    country_code { "PT" }
    postal_code { postal_code[:postcode].tr('^A-Za-z0-9', '') }
    language_code { "PT" }

    metadata {
      {
        language_code: "PT",
        country_code: "PT",
        postal_code: postal_code[:postcode]
      }
    }

    address {
      {
        label: '%{street_name}, %{building_number}, %{secondary_address}, %{city}, %{community}, %{state}, Portugal, %{postcode}' % postal_code,
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
        country: "Portugal",
        country_code: "PT"
      }
    }

    geodata {
      {
          coordinate: {
          lat: postal_code[:latitude],
          long: postal_code[:longitude]
        }
      }
    }
  end
end

private

def generate_random_postal_code_hash
  Faker::Address.full_address_as_hash(
    :street_name,
    :building_number,
    :city,
    :state,
    :secondary_address,
    :postcode,
    :community,
    :mail_box,
    :latitude,
    :longitude
  )
end
