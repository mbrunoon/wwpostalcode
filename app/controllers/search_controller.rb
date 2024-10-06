class SearchController < ApplicationController

  def create
    postal_codes = PostalCode.search(search_params)
    
    render json: postal_codes
  end

  private

  def search_params
    params.require(:search).permit(:postal_code, :language_code)
  end  

end
