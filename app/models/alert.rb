class Alert < ApplicationRecord
  include Postcodeable
  include TimeSlotable
  include MissionPreferences

  belongs_to :runner

  attr_accessor :comms, :expires_in
end
