module Postcodeable
  extend ActiveSupport::Concern

  included do
    belongs_to :postcode
  end

  def postcode_str
    postcode&.postcode
  end

  def postcode_str=(string)
    self.postcode = Postcode.find_or_initialize_by(postcode: string)
  end
end
