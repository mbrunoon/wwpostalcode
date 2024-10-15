class PagesController < ApplicationController
  def index
    postal_code_datas = {
      "total_postal_code": PostalCode.count,
      lasts: PostalCode.last(20)
    }
    render json: postal_code_datas, status: :ok
  end
end
