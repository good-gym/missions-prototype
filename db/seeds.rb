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
  default_radius: 5.0
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
  default_radius: 7.5
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
  default_radius: 5.0
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
  default_radius: 5.0
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
  default_radius: 5.0
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

def create_referral(postcode, time, referrer, coordinator)
  referral = referrer.referrals.build(
    coach: Coach.create!(name: Faker::Name.name),
    volunteers_needed: [2, 2, 2, 2, 3].sample,
    duration: [30, 60, 90].sample,
    confirmation_by: time - [1, 2, 3].sample.days,
    postcode_str: postcode
  )
  referral.time_slots_attributes = [
    { booking: referral, started_at: (time - 1.hours) },
    { booking: referral, started_at: (time - 2.hours) },
    { booking: referral, started_at: (time + 24.hours) }
  ]
  referral.save!

  Referral::Approve.call(referral, approver: coordinator)
  referral
end

# areas = ["Bristol", "Newham"]
# postcodes = areas.map { |area| MissionReferral.joins(coaches: [:residence, :area]).where("areas.location": area).order("random()").limit(3).pluck(:post_code) }

[
  ["E9 7JX"],
  ["BS14 9SL", "BS5 6RP", "BS4 1UF"], # Bristol
  ["NW3 2YH", "NW3 5RR", "NW1 8UE"], # Camden
  ["CR5 2JA", "CR0 1BX", "CR0 3QX"], # Croydon
  ["W5 4ES", "W5 4BL", "W3 8JP"], # Hounslow
  ["E6 3LZ", "E6 3HT", "E7 0NN"], # Newham
  ["SE1 5LP", "SE16 3QE", "SE5 7BB"], # Southwark
  ["YO32 3NL", "YO32 2QL", "YO10 3PA"] # York
].each do |area_postcodes|
  times = [
    1.week.from_now.beginning_of_week - 12.hours,
    1.week.from_now.beginning_of_week + 12.hours,
    2.week.from_now.beginning_of_week - 12.hours
  ]

  area_postcodes.each_with_index do |postcode, i|
    create_referral(postcode, times[i], referrer, coordinator)
  end
end

referral = create_referral("E97JX", 1.week.from_now.beginning_of_hour, referrer, coordinator)
referral.time_slots.each { |ts| ts.update(started_at: ts.started_at - 1.month) }
