class SearchController < ApplicationController
  def create
    cache_address = PostalCode.cache_address(search_params)

    postal_codes = Rails.cache.fetch(cache_address) { PostalCode.search(search_params) }
    postal_codes = JSON.parse(postal_codes)

    if postal_codes.blank?
      render status: :no_content
    else
      render json: postal_codes, status: :ok
    end
  end

  private

  def search_params
    params.require(:search).permit(:postal_code, :language_code, :country_code)
  end
end
