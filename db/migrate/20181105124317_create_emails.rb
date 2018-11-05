class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.references :sender, index: true, polymorphic: true
      t.references :object, index: true, polymorphic: true

      t.string :subject
      t.text :body

      t.timestamps
    end
  end
end
