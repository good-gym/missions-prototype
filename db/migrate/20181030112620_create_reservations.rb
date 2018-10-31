class CreateReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      t.references :runner, foreign_key: true
      t.references :referral, foreign_key: true

      t.timestamps
    end
  end
end
