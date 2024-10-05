class CreatePostalCodes < ActiveRecord::Migration[7.2]
  def change
    create_table :postal_codes do |t|
      
      t.string :language
      t.string :postal_code
      t.string :country_code
      
      t.jsonb :metadata
      t.json :address
      t.json :geodata

      t.timestamps
      
      t.index :language
      t.index :postal_code
      t.index :country_code
    end
  end
end
