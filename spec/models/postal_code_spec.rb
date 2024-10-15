require 'rails_helper'

RSpec.describe PostalCode, type: :model do
  before(:all) do
    @postal_code_pt_pt = FactoryBot.create(:default_postal_code_pt_pt)
    @postal_code_pt_es = FactoryBot.create(:default_postal_code_pt_es)
    @postal_code_pt_it = FactoryBot.create(:default_postal_code_pt_it)

    FactoryBot.create(:default_postal_code_es_es)
    FactoryBot.create(:default_postal_code_it_it)

    @postal_code_pt_pt_params = @postal_code_pt_pt.serializable_hash(only: [ :postal_code, :language_code, :country_code ]).symbolize_keys
  end

  context "validations" do
    it "validate uniqueness of postal code and country code" do
      postal_code_2 = PostalCode.new(@postal_code_pt_pt_params)

      expect(postal_code_2.valid?).to eq(false)
      expect(postal_code_2.errors[:postal_code].any?).to eq(true)
    end

    it "should return cache address with country code" do
      cache_address = PostalCode.cache_address(@postal_code_pt_pt_params)
      expect(cache_address).to eq("language/PT/country/PT/postal_code/0000000")
    end

    it "should return cache address without country code" do
      cache_address = PostalCode.cache_address(@postal_code_pt_pt_params.except(:country_code))
      expect(cache_address).to eq("language/PT/postal_code/0000000")
    end
  end

  context 'search' do
    it "should return PostalCode with postal_code and language_code params" do
      search_params = { postal_code: "0000-000", language_code: "PT" }
      postal_codes = JSON.parse(PostalCode.search(search_params))

      expect(postal_codes.first["metadata"]["postal_code"].tr('^A-Za-z0-9', '')).to eq(search_params[:postal_code].tr('^A-Za-z0-9', ''))
    end

    it "should return two PostalCode from different countries" do
      postal_codes = JSON.parse(PostalCode.search({ postal_code: "0000000" }))

      expect(postal_codes.count).to be >= 2
      expect(postal_codes[0]["metadata"]["country_code"]).not_to eq(postal_codes[1]["metadata"]["country_code"])
    end

    it "should return three PostalCode from different countries" do
      postal_codes = JSON.parse(PostalCode.search({ postal_code: "0000000", language_code: "PT" }))

      expect(postal_codes.count).to be >= 3

      returned_country_codes = postal_codes.map { |i| i["metadata"]["country_code"] }
      expect(returned_country_codes).to eq([ "PT", "ES", "IT" ])
    end

    it "should return two PostalCode from different countries and languages" do
      postal_codes = JSON.parse(PostalCode.search({ postal_code: "0000000", language_code: "PT" }))

      expect(postal_codes.count).to be >= 2

      returned_country_codes = postal_codes.map { |i| i["metadata"]["country_code"] }
      expect(returned_country_codes).to eq([ "PT", "ES", "IT" ])

      returned_language_codes = postal_codes.map { |i| i["metadata"]["language_code"] }
      expect(returned_language_codes).to eq([ "PT", "PT", "PT" ])
    end
  end
end
