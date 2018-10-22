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

  private

  DATA = YAML.load(File.read("config/fake_data.yml")).with_indifferent_access[:referrals]
  after_initialize :setup_fake_data

  def setup_fake_data
    if persisted?
      data = DATA[id]
      data.each { |key, value| value.gsub!("COACH", coach.public_name) }
      assign_attributes(data)
    end
  end
end
