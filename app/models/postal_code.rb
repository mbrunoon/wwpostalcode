class PostalCode < ApplicationRecord

  def self.search(search_params)
    postal_code = search_params[:postal_code]
    language    = search_params[:language] || "en"
    country     = search_params[:country] || "WorldWide"

    PostalCode.where(postal_code: postal_code)
  end

end
