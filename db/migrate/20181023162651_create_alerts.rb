class CreateAlerts < ActiveRecord::Migration[5.2]
  def change
    create_table :alerts do |t|
      t.references :runner, foreign_key: true

      t.string :location
      t.boolean :enabled, null: false, enabled: true

      t.float :radius
      t.references :postcode, foreign_key: true

      t.jsonb :weekly_schedule, null: false, default: "{}"

      t.timestamps
    end
  end
end
