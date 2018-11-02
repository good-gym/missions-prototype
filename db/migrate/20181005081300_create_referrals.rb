class CreateReferrals < ActiveRecord::Migration[5.2]
  def change
    create_table :referrals do |t|
      t.jsonb :preferences, null: false, default: "{}"

      t.references :coach, foreign_key: true
      t.references :referrer, foreign_key: true
      t.references :postcode, foreign_key: true

      # t.string :name, null: false
      # t.string :outcome, null: false
      # t.text :description, null: false
      #
      # t.text :note, null: false
      # t.text :risks, null: false
      # t.integer :risk_to_runner

      t.integer :volunteers_needed, null: false
      t.integer :duration, null: false
      t.datetime :confirmation_by

      t.timestamps
    end
  end
end
