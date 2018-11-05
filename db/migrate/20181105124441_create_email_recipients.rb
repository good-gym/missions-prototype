class CreateEmailRecipients < ActiveRecord::Migration[5.2]
  def change
    create_table :email_recipients do |t|
      t.references :email, foreign_key: true
      t.references :recipient, index: true, polymorphic: true

      t.timestamps
    end
  end
end
