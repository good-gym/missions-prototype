class CreateTimeSlots < ActiveRecord::Migration[5.2]
  def change
    create_table :time_slots do |t|
      t.references :booking, index: true, polymorphic: true
      t.datetime :started_at

      t.timestamps
    end
  end
end
