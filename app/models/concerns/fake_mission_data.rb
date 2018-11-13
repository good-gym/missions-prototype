module FakeMissionData
  extend ActiveSupport::Concern

  included do
    after_initialize :setup_fake_data
  end

  private

  DATA = YAML.load(File.read("config/fake_data.yml")).with_indifferent_access[:referrals]
  def setup_fake_data
    if persisted? && id.present?
      data = DATA[self.id]
      data.each { |key, value| value.gsub!("COACH", coach.public_name) }
      assign_attributes(data)
    end
  end
end
