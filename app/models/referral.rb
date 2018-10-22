class Referral < ApplicationRecord
  include Postcodeable
  include TimeSlotable

  belongs_to :referrer

  belongs_to :coach
  accepts_nested_attributes_for :coach

  attr_accessor :urgent
  attr_accessor :confirm_age

  attr_writer :title
  attr_accessor :subtitle
  attr_accessor :description

  attr_accessor :contact_details
  attr_accessor :task_notes
  attr_accessor :risk
  attr_accessor :risk_details

  attr_accessor :confirm_tools

  def title
    ["Clearing the garden for #{coach.public_name}"].sample
  end
end
