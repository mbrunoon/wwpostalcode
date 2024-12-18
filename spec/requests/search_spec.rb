require 'rails_helper'

RSpec.describe "Searches", type: :request do
  before(:all) do
    FactoryBot.create(:default_postal_code_pt)
    FactoryBot.create(:default_postal_code_es)
    FactoryBot.create(:default_postal_code_it)

    @headers = { "Content-Type": "application/json" }
    @search_params = { postal_code: "0000-000", country_code: "PT" }
  end

  describe "POST /search" do
    it "should return value from cache" do
      post "/search", headers: @headers, params: @search_params, as: :json
      expect(response.status).to eq(200)

      cache_address = PostalCode.cache_address(@search_params)
      cached_data = JSON.parse(Rails.cache.read(cache_address))

      expect(cached_data.blank?).to eq(false)
      expect(cached_data.first["metadata"]["postal_code"]).to eq(@search_params[:postal_code])
      expect(cached_data.first["metadata"]["country_code"]).to eq(@search_params[:country_code])
    end

    it "should return one postal code from PT" do
      params = { postal_code: "0000-000", country_code: "PT" }
      post "/search", headers: @headers, params: params, as: :json
      expect(response.status).to eq(200)

      result = JSON.parse(response.body)
      expect(result.length).to eq(1)
      expect(result[0]["metadata"]["country_code"]).to eq("PT")
    end

    it "should return two postal code from PT" do
      PostalCode.create(
        postal_code: "0000-000",
        country_code: "PT",
        metadata: { postal_code: "0000-000", country_code: "PT" },
        address: "address 2",
        geodata: "geodata 2"
      )

      Rails.cache.clear

      params = { postal_code: "0000-000", country_code: "PT" }
      post "/search", headers: @headers, params: params, as: :json
      expect(response.status).to eq(200)

      result = JSON.parse(response.body)

      expect(result.length).to eq(2)
      expect(result[0]["metadata"]["country_code"]).to eq("PT")
      expect(result[1]["metadata"]["country_code"]).to eq("PT")
    end

    it "should return one postal code from ES" do
      params = { postal_code: "0000-000", country_code: "ES" }
      post "/search", headers: @headers, params: params, as: :json
      expect(response.status).to eq(200)

      result = JSON.parse(response.body)
      expect(result.length).to eq(1)
      expect(result[0]["metadata"]["country_code"]).to eq("ES")
    end

    it "should return world wide postal code" do
      params = { postal_code: "0000-000" }
      post "/search", headers: @headers, params: params, as: :json
      expect(response.status).to eq(200)

      result = JSON.parse(response.body)
      expect(result.length).to eq(3)

      countries = result.map { |i| i["metadata"]["country_code"] }
      expect(countries).to eq([ "PT", "ES", "IT" ])
    end
  end
end
