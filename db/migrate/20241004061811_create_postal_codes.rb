class CreatePostalCodes < ActiveRecord::Migration[7.2]
  def change
    create_table :postal_codes do |t|
      t.jsonb :metadata
      t.json :address
      t.json :geodata

      t.timestamps
    end
  end
end
