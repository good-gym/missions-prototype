class CreatePostcodes < ActiveRecord::Migration[5.2]
  def change
    create_table :postcodes do |t|
      t.string :postcode
      t.float :lat
      t.float :lng

      t.timestamps
    end

    add_index :postcodes, :postcode, unique: true
  end
end
