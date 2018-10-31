class CreateReservationTimeSlots < ActiveRecord::Migration[5.2]
  def change
    create_table :reservation_time_slots do |t|
      t.references :reservation, foreign_key: true
      t.references :time_slot, foreign_key: true

      t.timestamps
    end
  end
end
