class PagesController < ApplicationController

  def index    
    postal_codes = {
      search: {
        terms: "0000-000",
        total_found: 1,
        current_page: 1,
        total_pages: 1,
        language: "PT-pt"
      },
      postal_codes: {
        metadata: {
          country_code: "PT",
          postal_code: "0000-000",          
        },
        address: {
          label: "street, number, complement, area_lvl_1.name, area_lvl_2.name, ..., cep",
          street: "Rua",
          number: "127",
          complement: "",
          area_lvl_1: {name: "Concelho"},
          area_lvl_2: {name: "Cidade"},
          area_lvl_3: {name: "Distrito"},
          area_lvl_4: {name: "Portugal", country_code: "PT"},
          area_lvl_5: nil,
          area_lvl_6: nil,
          area_lvl_7: nil,
          postal_code: "0000-000"
        },
        geodata: {
          coordinate: {
            lat: 41.183395,
            long: -8.638279
          }
        }
      }
    }

    render json: postal_codes, status: :ok
  end

end


