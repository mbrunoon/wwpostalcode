require 'rails_helper'

RSpec.describe PostalCode, type: :model do        

  let(:search_params) { { postal_code: "15040270", language_code: "PT", country_code: "PT" } }  

  context "validations" do
    it "validate uniqueness of postal code and country code" do
      PostalCode.create(search_params)

      postal_code_2 = PostalCode.new(search_params)
      
      expect(postal_code_2.valid?).to eq(false)
      expect(postal_code_2.errors[:postal_code].any?).to eq(true)      
    end

    it "should return cache address with country code" do      
      cache_address = PostalCode.cache_address(search_params)
      expect(cache_address).to eq("language/PT/country/PT/postal_code/15040270")
    end

    it "should return cache address without country code" do      
      cache_address = PostalCode.cache_address(search_params.except(:country_code))
      expect(cache_address).to eq("language/PT/postal_code/15040270")
    end

  end  

  context 'search' do
    it "should return PostalCode with postal_code and language_code params" do
      PostalCode.create(search_params)

      new_search_params = search_params.except(:country_code)
      postal_codes = PostalCode.search(new_search_params)
      
      expect(postal_codes.first.postal_code).to eq(search_params[:postal_code].tr('^A-Za-z0-9', ''))
    end

    it "should return two PostalCode from different countries" do
      PostalCode.create({ postal_code: "0000000", language_code: "PT", country_code: "PT" })
      PostalCode.create({ postal_code: "0000000", language_code: "PT", country_code: "ES" })
      
      postal_codes = PostalCode.search({ postal_code: "0000000"})
      
      expect(postal_codes.count).to eq(2)
      expect(postal_codes.pluck(:country_code)).to eq(["PT", "ES"])      
    end

    it "should return three PostalCode from different countries" do
      PostalCode.create({ postal_code: "0000000", language_code: "PT", country_code: "PT" })
      PostalCode.create({ postal_code: "0000000", language_code: "PT", country_code: "ES" })
      PostalCode.create({ postal_code: "0000000", language_code: "PT", country_code: "IE" })
      
      postal_codes = PostalCode.search({ postal_code: "0000000", language_code: "PT"})
      
      expect(postal_codes.count).to eq(3)
      expect(postal_codes.pluck(:country_code)).to eq(["PT", "ES", "IE"])
    end

    it "should return two PostalCode from different countries and languages" do      
      PostalCode.new({ postal_code: "0000000", language_code: "PT", country_code: "PT" })
      PostalCode.create({ postal_code: "0000000", language_code: "PT", country_code: "ES" })
      PostalCode.create({ postal_code: "0000000", language_code: "PT", country_code: "IE" })

      PostalCode.create({ postal_code: "0000000", language_code: "EN", country_code: "PT" })
      PostalCode.create({ postal_code: "0000000", language_code: "EN", country_code: "ES" })            

      postal_codes = PostalCode.search({ postal_code: "0000000", language_code: "EN"})
             
      expect(postal_codes.count).to eq(2)
      expect(postal_codes.pluck(:country_code)).to eq(["PT", "ES"])      
    end

  end

end