# From the GoodGym app
# data = Runner.mission_verified.includes(:pairing_preference).find_each.map { |r| postcode = Postcode.find_by(postcode: r.search_postcode); { name: r.first_name, postcode: r.postcode, lat: postcode&.lat, lng: postcode&.lng, radius: r.pairing_preference&.distance} }
# File.open("tmp/runners.yml", "w") { |f| f.puts data.to_yaml }

task load_runners: :environment do
  runners_data = YAML.load(File.read("tmp/runners.yml"))
  pp runners_data
  runners_data.each do |runner_data|
    next if runner_data[:lat].nil?

    puts runner_data[:postcode]
    postcode = Postcode.postcode!(
      runner_data[:postcode], lat: runner_data[:lat], lng: runner_data[:lng]
    )
    next unless postcode&.valid?

    runner = Runner.create!(
      name: runner_data[:name],
      postcode: postcode,
      default_radius: runner_data[:radius] || 5,
      preferences: { lifting: true, cats: true, dogs: true }
    )
    runner.alerts.create!(
      enabled: true,
      radius: runner.default_radius,
      postcode: postcode,
      weekly_schedule: WeeklySchedule.default(:home)
    )
  end
  # pp data
end
