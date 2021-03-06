class PostcodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    ukpc = UKPostcode.parse(value)
    unless ukpc.full_valid?
      record.errors[attribute] << "not recognised as a UK postcode"
    end
  end
end
