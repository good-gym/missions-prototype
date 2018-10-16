# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

time1 = 1.week.from_now.beginning_of_week - 12.hours
times = [{ started_at: (time1) }]

runner = Runner.create(
  name: "Patrick",
  postcode_str: "E9 7HW",
  default_radius: 5.0,
  preferences: { lifting: true, cats: true, dogs: true }
)
runner.availabilities
  .create!(
    radius: 5.0,
    postcode_str: "E9 7HW",
    time_slots_attributes: times
  )

runner = Runner.create(
  name: "Ivo",
  postcode_str: "E2 7RG",
  default_radius: 7.5,
  preferences: { lifting: true, cats: true, dogs: true }
)
runner.availabilities
  .create!(
    radius: 5.0,
    postcode_str: "E2 7RG",
    time_slots_attributes: times
  )

runner = Runner.create(
  name: "Polly",
  postcode_str: "W12 7PJ",
  default_radius: 5.0,
  preferences: { lifting: false, cats: true, dogs: true }
)
runner.availabilities
  .create!(
    radius: 5.0,
    postcode_str: "W12 7PJ",
    time_slots_attributes: times
  )

runner = Runner.create(
  name: "James",
  postcode_str: "W11 4UL",
  default_radius: 5.0,
  preferences: { lifting: true, cats: true, dogs: true }
)
runner.availabilities
  .create!(
    radius: 5.0,
    postcode_str: "W11 4UL",
    time_slots_attributes: times
  )

runner = Runner.create(
  name: "Paul",
  postcode_str: "NW1 8QP",
  default_radius: 5.0,
  preferences: { lifting: true, cats: true, dogs: true }
)
runner.availabilities
  .create!(
    radius: 5.0,
    postcode_str: "NW1 8QP",
    time_slots_attributes: times
  )

referrer = Referrer.create(name: "Bob")
referrer.referrals.create!(
  coach: Coach.create!(name: "Mortimer"),
  postcode_str: "NW1 8QP",
  time_slots_attributes: [
    { started_at: (time1 - 1.hours) },
    { started_at: (time1 - 2.hours) },
    { started_at: (time1 + 24.hours) }
  ]
)
