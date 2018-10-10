class CreateAvailabilities < ActiveRecord::Migration[5.2]
  def change
    create_table :availabilities do |t|
      t.references :runner, foreign_key: true
      t.references :postcode, foreign_key: true
      t.float :radius

      t.timestamps
    end
  end
end
