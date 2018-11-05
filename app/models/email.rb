class Email < ApplicationRecord
  belongs_to :object, polymorphic: true
  belongs_to :sender, polymorphic: true
  has_many :email_recipients, dependent: :destroy

  def recipients
    email_recipients.map(&:recipient)
  end
end
