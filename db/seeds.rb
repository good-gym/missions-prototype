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
runner.alerts.create!(
  location: "Home",
  enabled: true,
  radius: 5.0,
  postcode_str: "E9 7HW",
  weekly_schedule: WeeklySchedule.default
)
# runner.availabilities
#   .create!(
#     radius: 5.0,
#     postcode_str: "E9 7HW",
#     time_slots_attributes: times
#   )

runner = Runner.create(
  name: "Ivo",
  postcode_str: "E2 7RG",
  default_radius: 7.5,
  preferences: { lifting: true, cats: true, dogs: true }
)
runner.alerts.create!(
  location: "Home",
  enabled: true,
  radius: 5.0,
  postcode: runner.postcode,
  weekly_schedule: WeeklySchedule.default
)

# runner.availabilities
#   .create!(
#     radius: 5.0,
#     postcode_str: "E2 7RG",
#     time_slots_attributes: times
#   )

runner = Runner.create(
  name: "Polly",
  postcode_str: "W12 7PJ",
  default_radius: 5.0,
  preferences: { lifting: false, cats: true, dogs: true }
)
runner.alerts.create!(
  location: "Home",
  enabled: true,
  radius: 5.0,
  postcode: runner.postcode,
  weekly_schedule: WeeklySchedule.default
)
# runner.availabilities
#   .create!(
#     radius: 5.0,
#     postcode_str: "W12 7PJ",
#     time_slots_attributes: times
#   )

runner = Runner.create(
  name: "James",
  postcode_str: "W11 4UL",
  default_radius: 5.0,
  preferences: { lifting: true, cats: true, dogs: true }
)
runner.alerts.create!(
  location: "Home",
  enabled: true,
  radius: 5.0,
  postcode: runner.postcode,
  weekly_schedule: WeeklySchedule.default
)
# runner.availabilities
#   .create!(
#     radius: 5.0,
#     postcode_str: "W11 4UL",
#     time_slots_attributes: times
#   )

runner = Runner.create(
  name: "Paul",
  postcode_str: "NW1 8QP",
  default_radius: 5.0,
  preferences: { lifting: true, cats: true, dogs: true }
)
runner.alerts.create!(
  location: "Home",
  enabled: true,
  radius: 5.0,
  postcode: runner.postcode,
  weekly_schedule: WeeklySchedule.default
)
# runner.availabilities
#   .create!(
#     radius: 5.0,
#     postcode_str: "NW1 8QP",
#     time_slots_attributes: times
#   )

coordinator = Coordinator.create(name: "Gillian")

referrer = Referrer.create(name: "Bob")

# areas = ["Bristol", "Newham"]
# postcodes = areas.map { |area| MissionReferral.joins(coaches: [:residence, :area]).where("areas.location": area).order("random()").limit(3).pluck(:post_code) }

[
  ["E9 7JX"],
  ["BS14 9SL", "BS5 6RP", "BS4 1UF"], # Bristol
  ["E6 3LZ", "E6 3HT", "E7 0NN"], # Newham
  # ["YO32 3NL", "YO32 2QL", "YO10 3PA"],
  # ["SE1 5LP", "SE16 3QE", "SE5 7BB"],
  # ["W5 4ES", "W5 4BL", "W3 8JP"],
  # ["CR5 2JA", "CR0 1BX", "CR0 3QX"]
].each do |area_postcodes|
  times = [
    1.week.from_now.beginning_of_week - 12.hours,
    1.week.from_now.beginning_of_week + 12.hours,
    2.week.from_now.beginning_of_week - 12.hours
  ]

  area_postcodes.each_with_index do |postcode, i|
    referral = referrer.referrals.build(
      coach: Coach.create!(name: Faker::Name.name),
      volunteers_needed: [2, 2, 2, 2, 3].sample,
      duration: [30, 60, 90].sample,
      confirmation_by: times[i] - [1, 2, 3].sample.days,
      postcode_str: postcode,
      approved_by: coordinator, approved_at: Time.now
    )
    referral.time_slots_attributes = [
      { booking: referral, started_at: (times[i] - 1.hours) },
      { booking: referral, started_at: (times[i] - 2.hours) },
      { booking: referral, started_at: (times[i] + 24.hours) }
    ]
    referral.save!
  end
end
