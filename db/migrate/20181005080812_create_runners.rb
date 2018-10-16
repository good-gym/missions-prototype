class CreateRunners < ActiveRecord::Migration[5.2]
  def change
    create_table :runners do |t|
      t.string :name
      t.references :postcode, foreign_key: true
      t.float :default_radius
      t.jsonb :preferences, null: false, default: "{}"

      t.timestamps
    end
  end
end
