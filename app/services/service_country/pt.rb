module ServiceCountry
  class Pt < ApplicationService

    attr_reader :postal_code

    def initialize(postal_code)
      @postal_code = postal_code
    end
  
    def call
      address = ServiceProvider::GeoApiPt.call(@postal_code)
      return address
    end
  
  end  
end