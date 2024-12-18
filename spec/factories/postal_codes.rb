FactoryBot.define do
  factory :default_postal_code_pt, class: PostalCode do
    country_code { "PT" }
    postal_code { "0000000" }
    metadata {
      {
        country_code: "PT",
        postal_code: "0000-000"
      }
    }
    address { "address" }
    geodata { "geodata" }
  end

  factory :default_postal_code_it, class: PostalCode do
    country_code { "IT" }
    postal_code { "0000000" }
    metadata {
      {
        country_code: "IT",
        postal_code: "0000-000"
      }
    }
    address { "address" }
    geodata { "geodata" }
  end

  factory :default_postal_code_es, class: PostalCode do
    country_code { "ES" }
    postal_code { "0000000" }
    metadata {
      {
        country_code: "ES",
        postal_code: "0000-000"
      }
    }
    address { "address" }
    geodata { "geodata" }
  end
end
