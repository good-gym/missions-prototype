class Calendar
  attr_reader :date

  def initialize(date = Date.today)
    @date = date.to_date.beginning_of_month
  end

  def weeks
    Array.new(5) do |w|
      Array.new(7) { |d| date.beginning_of_week + (w*7) + d }
    end
  end
end
