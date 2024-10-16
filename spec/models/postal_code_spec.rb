require 'rails_helper'

RSpec.describe PostalCode, type: :model do
  before(:all) do
    FactoryBot.create(:default_postal_code_pt)
    FactoryBot.create(:default_postal_code_es)
    FactoryBot.create(:default_postal_code_it)
  end

  context "validations" do
    it "validate presence postal_code" do
      postal_code = PostalCode.new({ postal_code: nil, country_code: "PT" })

      expect(postal_code.valid?).to eq(false)
      expect(postal_code.errors[:postal_code].any?).to eq(true)
    end

    it "validate presence country_code" do
      postal_code = PostalCode.new({ postal_code: "0000-000", country_code: nil })

      expect(postal_code.valid?).to eq(false)
      expect(postal_code.errors[:country_code].any?).to eq(true)
    end

    it "validate presence country_code" do
      postal_code = PostalCode.new({ postal_code: nil, country_code: nil })

      expect(postal_code.valid?).to eq(false)
      expect(postal_code.errors[:postal_code].any?).to eq(true)
      expect(postal_code.errors[:country_code].any?).to eq(true)
    end
  end

  context "search" do
    it "should return world wide postal codes" do
      postal_codes = JSON.parse(PostalCode.search({ postal_code: "0000-000" }))
      countries = postal_codes.map { |i| i["metadata"]["country_code"] }.uniq

      expect(countries.length).to be >= 2
    end

    it "should return world wide postal codes" do
      postal_codes = JSON.parse(PostalCode.search({ postal_code: "0000-000", country_code: "PT" }))
      countries = postal_codes.map { |i| i["metadata"]["country_code"] }.uniq
      expect(countries.length).to eq(1)
    end

    it "should return Portugal postal codes" do
      postal_codes = PostalCode.search({ postal_code: "0000-000", country_code: "PT" })
      postal_codes = JSON.parse(postal_codes)
      expect(postal_codes.length).to be >= 1

      country = postal_codes.map { |i| i["metadata"]["country_code"] }.uniq
      expect(country[0]).to eq("PT")
    end
  end
end
