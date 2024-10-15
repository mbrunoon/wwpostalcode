class PostalCode < ApplicationRecord
  SERIALIZABLE_FIELDS = %i[metadata address geodata]
  DEFAULT_LANGUAGE_CODE = "PT"

  validates :postal_code, presence: true
  validates :country_code, presence: true
  validates :language_code, presence: true

  validates :postal_code, uniqueness: { scope: [ :country_code, :language_code ], message: "Postal Code already exists for this country and language." }

  before_save :normalize_fields_to_save

  def self.search(search_params)
    search_params = normalize_fields(search_params)

    postal_code = search_params[:postal_code]
    country     = search_params[:country_code]
    language    = search_params[:language_code]

    search_result = if country.present?
      PostalCode.where(postal_code: postal_code, language_code: language, country_code: country)
    else
      PostalCode.where(postal_code: postal_code, language_code: language)
    end

    search_result.to_json(only: SERIALIZABLE_FIELDS)
  end

  def self.cache_address(search_params)
    search_params = normalize_fields(search_params)

    if search_params[:country_code].present?
      "language/#{search_params[:language_code]}/country/#{search_params[:country_code]}/postal_code/#{search_params[:postal_code]}"
    else
      "language/#{search_params[:language_code]}/postal_code/#{search_params[:postal_code]}"
    end
  end

  def self.normalize_fields(params_hash)
    {
      postal_code: normalized_postal_code(params_hash[:postal_code]),
      language_code: params_hash[:language_code]&.upcase || DEFAULT_LANGUAGE_CODE,
      country_code: params_hash[:country_code]&.upcase
    }.compact
  end

  def self.normalized_postal_code(postal_code)
    "#{postal_code}".tr("^A-Za-z0-9", "")
  end

  private

  def normalize_fields_to_save
    self.postal_code = self.class.normalized_postal_code(self.postal_code)
    self.language_code = self.language_code.upcase
    self.country_code = self.country_code.upcase
  end
end
