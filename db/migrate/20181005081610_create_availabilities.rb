class CreateAvailabilities < ActiveRecord::Migration[5.2]
  def change
    create_table :availabilities do |t|
      t.references :runner, foreign_key: true
      t.references :postcode, foreign_key: true
      t.float :radius
      t.jsonb :preferences, null: false, default: "{}"

      t.timestamps
    end
  end
end
