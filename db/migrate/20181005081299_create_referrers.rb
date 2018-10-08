class CreateReferrers < ActiveRecord::Migration[5.2]
  def change
    create_table :referrers do |t|
      t.string :name

      t.timestamps
    end
  end
end
