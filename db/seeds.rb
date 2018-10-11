# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

times = [{ started_at: (2.week.from_now.beginning_of_week - 12.hours) }]

runner = Runner.create(name: "Patrick")
runner.availabilities
  .create!(
    radius: 5.0,
    postcode_str: "E9 7HW",
    time_slots_attributes: times
  )

runner = Runner.create(name: "Ivo")
runner.availabilities
  .create!(
    radius: 5.0,
    postcode_str: "E2 7RG",
    time_slots_attributes: times
  )

  runner = Runner.create(name: "Polly")
  runner.availabilities
    .create!(
      radius: 5.0,
      postcode_str: "W12 7PJ",
      time_slots_attributes: times
    )

  runner = Runner.create(name: "James")
  runner.availabilities
    .create!(
      radius: 5.0,
      postcode_str: "W11 4UL",
      time_slots_attributes: times
    )

  runner = Runner.create(name: "Paul")
  runner.availabilities
    .create!(
      radius: 5.0,
      postcode_str: "NW1 8QP",
      time_slots_attributes: times
    )

referrer = Referrer.create(name: "Bob")
