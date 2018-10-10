class Availability < ApplicationRecord
  include Postcodeable
  include TimeSlotable

  belongs_to :runner

  scope :owned_by, ->(runner) { where(runner: runner) }
  scope :not_owned_by, ->(runner) { where.not(runner: runner) }
end
