class Referral < ApplicationRecord
  include Postcodeable
  include TimeSlotable

  belongs_to :referrer
  
  belongs_to :coach
  accepts_nested_attributes_for :coach

  attr_accessor :urgent
  attr_accessor :confirm_age

  attr_accessor :title
  attr_accessor :subtitle
  attr_accessor :description

  attr_accessor :contact_details
  attr_accessor :task_notes
  attr_accessor :risk
  attr_accessor :risk_details

  attr_accessor :confirm_tools
end
