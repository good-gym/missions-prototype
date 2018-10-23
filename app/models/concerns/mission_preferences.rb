module MissionPreferences
  extend ActiveSupport::Concern

  included do
    serialize :preferences, HashSerializer
  end

  def preferences
    p = super
    p.empty? ? { lifting: true, cats: true, dogs: true } : p
  end

  def preferences=(data)
    super data.map { |k, v| [k, ActiveModel::Type::Boolean.new.cast(v)] }.to_h
  end
end
