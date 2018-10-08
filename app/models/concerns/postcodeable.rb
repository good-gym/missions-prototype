module Postcodeable
  extend ActiveSupport::Concern

  included do
    belongs_to :postcode
  end

  def postcode_str
    postcode&.postcode
  end

  def postcode_str=(string)
    self.postcode = Postcode.first_or_initialize(postcode: string)
  end
end
