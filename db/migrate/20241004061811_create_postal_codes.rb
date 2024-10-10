class CreatePostalCodes < ActiveRecord::Migration[7.2]
  def change
    create_table :postal_codes do |t|
      
      t.string :language_code
      t.string :postal_code
      t.string :country_code
      
      t.jsonb :metadata
      t.json :address
      t.json :geodata

      t.timestamps
            
      t.index [:language_code, :postal_code, :country_code], unique: true
      t.index [:language_code, :postal_code]
    end
  end
end
