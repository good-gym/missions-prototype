class EmailRecipient < ApplicationRecord
  belongs_to :email
  belongs_to :recipient, polymorphic: true
end
