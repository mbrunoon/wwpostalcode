module ServiceCountry
  class Pt < ApplicationService
    def self.search(postal_code)
      ServiceProvider::CttApiV1.call(postal_code)
    end
  end
end
