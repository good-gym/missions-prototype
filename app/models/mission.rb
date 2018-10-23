class Mission
  include ActiveModel::Model

  attr_accessor :started_at, :title

  def image_url
    "https://d2tfd645274ffx.cloudfront.net/uploads/photo/122584/image/fixed_small-f9f1a8fc856ea9ab7253343b6165af06.jpg"
  end

  def self.on_days(date)
    return [] unless (date - Date.today).to_i == 5

    [
      Mission.new(
        started_at: date,
        title: "Misison"
      )
    ]
  end
end
