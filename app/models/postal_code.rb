class PostalCode < ApplicationRecord  

  SERIALIZABLE_FIELDS = %i[metadata address geodata]
  DEFAULT_LANGUAGE_CODE = "PT"  

  validates :postal_code, uniqueness: { scope: [:country_code, :language_code], message: "Postal Code already exists for this country and language." }  

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

  private      

  def self.normalize_fields(params_hash)
    params_hash[:language_code] = params_hash[:language_code]&.upcase || DEFAULT_LANGUAGE_CODE
    params_hash[:country_code]  = params_hash[:country_code]&.upcase
    params_hash[:postal_code]   = params_hash[:postal_code].tr('^A-Za-z0-9', '')

    params_hash
  end  

end
