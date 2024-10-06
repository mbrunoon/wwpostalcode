class PostalCode < ApplicationRecord

  def self.search(search_params)
    postal_code = search_params[:postal_code]
    country     = search_params[:country] || nil
    language    = search_params[:language] || "en"    


    PostalCode.where(postal_code: postal_code)
  end

end
