module ServiceProvider
  class CttApiV1 < ApplicationService
    require "net/http"
    require "json"
    require "active_record"


    attr_reader :postal_code

    PROVIDER_URI = "https://www.cttcodigopostal.pt/api/v1/#{ENV["PROVIDER_CTT_KEY"]}/"
    def initialize(postal_code)
      @postal_code = postal_code.insert(4, "-")
      @postal_code_raw = postal_code
    end

    def call
      uri = URI.parse(PROVIDER_URI + @postal_code)
      headers = { "Accept": "application/json" }
      data = Net::HTTP.get(uri, headers)
      results = JSON.parse(data)

      results.map do |result|
        {
          postal_code: @postal_code_raw,
          country_code: "PT",
          metadata: {
            postal_code: @postal_code_raw,
            country_code: "PT"
          },
          address: {
            street: result["morada"],
            number: result["porta"],
            area_lvl_1: { name: result["localidade"], type: "localidade" },
            area_lvl_2: { name: result["freguesia"], type: "freguesia" },
            area_lvl_3: { name: result["concelho"], type: "concelho" },
            area_lvl_4: { name: result["distrito"], type: "distrito" },
            postal_code: @postal_code,
            country: "Portugal",
            country_code: "PT"
          }.compact,
          geodata: {
            coordinate: {
              lat: result["latitude"],
              long: result["longitude"]
            }.compact
          }
        }
      end
    end
  end
end
