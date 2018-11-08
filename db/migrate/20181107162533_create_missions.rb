class CreateMissions < ActiveRecord::Migration[5.2]
  def change
    create_table :missions do |t|
      t.datetime :started_at, null: false

      t.timestamps
    end

    add_reference :referrals, :mission, index: true
  end
end
