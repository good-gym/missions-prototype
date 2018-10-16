module MissionPreferences
  extend ActiveSupport::Concern

  included do
    serialize :preferences, HashSerializer
  end

  def preferences
    p = super
    p.empty? ? { lifting: true, cats: true, dogs: true } : p
  end
end
