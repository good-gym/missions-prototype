class Coach < ApplicationRecord
  attr_accessor :title
  attr_accessor :alias
  attr_accessor :telephone_number

  attr_accessor :address_line_1
  attr_accessor :address_line_2
  attr_accessor :city
  attr_accessor :postcode

  def self.fake
    new(
      title: %w[Mr Mrs Ms].sample,
      name: Faker::Name.name,
      address_line_1: Faker::Address.street_address,
      city: Faker::Address.city,
      postcode: Faker::Address.zip_code
    )
  end

  def public_name
    [title || "Mr", first_name.first].join(" ")
  end

  def first_name
    name.split.first
  end
end
