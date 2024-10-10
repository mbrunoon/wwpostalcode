require 'rails_helper'

RSpec.describe "Searches", type: :request do

  let(:headers) { { "Content-Type": "application/json" } }
  let(:search_params) { { postal_code: "15040-270", language_code: "PT", country_code: "PT"} }  
  

  describe "POST /search" do
    it "should return value from cache" do      
      PostalCode.create({ postal_code: "15040270", language_code: "PT", country_code: "PT"})

      post "/search", headers: headers, params: search_params, as: :json
      expect(response.status).to eq(200)
      
      cache_address = PostalCode.cache_address(search_params)
      
      expect( Rails.cache.read(cache_address).blank? ).to eq(false)      
    end

    it "should return two postal codes from two different countries" do      
      PostalCode.create({ postal_code: "15040270", language_code: "PT", country_code: "PT"})
      PostalCode.create({ postal_code: "15040270", language_code: "PT", country_code: "ES"})

      post "/search", headers: headers, params: search_params.except(:country_code), as: :json
      expect(response.status).to eq(200)
      
      data = JSON.parse(response.body)
      expect(data.length).to eq(2)
    end

    it "should return one postal codes from only from PT country" do      
      PostalCode.create({ postal_code: "15040270", language_code: "PT", country_code: "PT"})
      PostalCode.create({ postal_code: "15040270", language_code: "PT", country_code: "ES"})

      post "/search", headers: headers, params: search_params, as: :json
      expect(response.status).to eq(200)
            
      data = JSON.parse(response.body)
      expect(data.length).to eq(1)
      expect(data[0]["country_code"]).to eq("PT")
    end

    it "should return one postal codes from only from PT country with ES language" do      
      PostalCode.create({ postal_code: "15040270", language_code: "PT", country_code: "PT"})
      PostalCode.create({ postal_code: "15040270", language_code: "PT", country_code: "ES"})
      PostalCode.create({ postal_code: "15040270", language_code: "ES", country_code: "PT"})
      PostalCode.create({ postal_code: "15040270", language_code: "ES", country_code: "ES"})

      search_params[:language_code] = "ES"

      post "/search", headers: headers, params: search_params, as: :json
      expect(response.status).to eq(200)
            
      data = JSON.parse(response.body)
      expect(data.length).to eq(1)
      expect(data[0]["country_code"]).to eq("PT")
    end

    it "should return 204 no content status" do
      search_params[:postal_code] = "9999TEST"

      post "/search", headers: headers, params: search_params, as: :json
      expect(response.status).to eq(204)                  
      expect(response.body).to eq("")
    end

  end
end
