class CreateAlerts < ActiveRecord::Migration[5.2]
  def change
    create_table :alerts do |t|
      t.references :runner, foreign_key: true
      t.references :postcode, foreign_key: true
      t.float :radius
      t.datetime :expires_at
      t.datetime :cancelled_at

      t.jsonb :preferences, null: false, default: "{}"

      t.timestamps
    end
  end
end
