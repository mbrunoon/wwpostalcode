module ServiceProvider
  class GeoApiPt < ApplicationService
    
    require 'net/http'
    require 'json'

    attr_reader :postal_code

    PROVIDER_URI = 'https://json.geoapi.pt/cp/'

    def initialize(postal_code)
      @postal_code = postal_code
    end

    def call
      data = Net::HTTP.get_response(URI.parse('2495-300'))      
      JSON.parse(data.body)
    end

  end
end