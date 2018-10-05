class CreateReferrals < ActiveRecord::Migration[5.2]
  def change
    create_table :referrals do |t|
      t.references :coach, foreign_key: true

      t.timestamps
    end
  end
end
