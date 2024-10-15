require 'rails_helper'

RSpec.describe "Searches", type: :request do  
  
  before(:all) do            
    FactoryBot.create(:default_postal_code_pt_pt)
    FactoryBot.create(:default_postal_code_pt_es)
    FactoryBot.create(:default_postal_code_pt_it)

    FactoryBot.create(:default_postal_code_es_pt)
    FactoryBot.create(:default_postal_code_es_es)
    FactoryBot.create(:default_postal_code_es_it)

    @headers = { "Content-Type": "application/json" }
    @search_params = { postal_code: "0000-000", language_code: "PT", country_code: "PT"}
  end  

  describe "POST /search" do
    it "should return value from cache" do            
      post "/search", headers: @headers, params: @search_params, as: :json
      expect(response.status).to eq(200)
      
      cache_address = PostalCode.cache_address(@search_params)
      cached_data = JSON.parse(Rails.cache.read(cache_address))
            
      expect(cached_data.blank? ).to eq(false)      
      expect(cached_data.first["metadata"]["postal_code"] ).to eq(@search_params[:postal_code])
      expect(cached_data.first["metadata"]["country_code"] ).to eq(@search_params[:country_code])
    end

    it "should return two postal codes from differents countries" do            
      post "/search", headers: @headers, params: @search_params.except(:country_code), as: :json
      expect(response.status).to eq(200)
      
      data = JSON.parse(response.body)
      expect(data.length).to be >= 2
    end

    it "should return one postal codes from only from PT country" do            
      post "/search", headers: @headers, params: @search_params, as: :json
      expect(response.status).to eq(200)
            
      data = JSON.parse(response.body)
      expect(data.length).to eq(1)
      expect(data[0]["metadata"]["country_code"]).to eq("PT")
    end

    it "should return one postal codes from only from PT country with ES language" do          
      @search_params[:language_code] = "ES"

      post "/search", headers: @headers, params: @search_params, as: :json
      expect(response.status).to eq(200)
            
      data = JSON.parse(response.body)
      expect(data.length).to be >= 1
      expect(data[0]["metadata"]["language_code"]).to eq("ES")
      expect(data[0]["metadata"]["country_code"]).to eq("PT")
    end

    it "should return 204 no content status" do
      @search_params[:postal_code] = "9999TEST"      
      post "/search", headers: headers, params: @search_params, as: :json
      
      expect(response.status).to eq(204)                  
      expect(response.body).to eq("")
    end

  end
end
