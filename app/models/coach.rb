class Coach < ApplicationRecord
  attr_accessor :title
  attr_accessor :alias
  attr_accessor :telephone_number

  attr_accessor :address_line_1
  attr_accessor :address_line_2
  attr_accessor :city
  attr_accessor :postcode

  TITLES = %w[Capt Col Dr Lady Major Miss Mr Mrs Ms Mx Prof Rev Sir].freeze
  def self.titles
    TITLES
  end

  def self.fake
    new(
      title: TITLES.sample,
      name: Faker::Name.name,
      address_line_1: Faker::Address.street_address,
      city: Faker::Address.city,
      postcode: Faker::Address.zip_code
    )
  end

  def public_name
    [title || "Mr", first_name.first].join(" ")
  end

  def private_name
    [title, name, "of", postcode].join(" ")
  end

  def first_name
    name.split.first
  end
end
