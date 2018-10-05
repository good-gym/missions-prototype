class CreateCoaches < ActiveRecord::Migration[5.2]
  def change
    create_table :coaches do |t|
      t.string :name
      t.references :postcode, foreign_key: true

      t.timestamps
    end
  end
end
