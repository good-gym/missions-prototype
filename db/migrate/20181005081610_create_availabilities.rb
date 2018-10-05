class CreateAvailabilities < ActiveRecord::Migration[5.2]
  def change
    create_table :availabilities do |t|
      t.references :owner, index: true, polymorphic: true
      t.references :postcode, foreign_key: true
      t.float :radius

      t.timestamps
    end
  end
end
