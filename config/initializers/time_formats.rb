Date::DATE_FORMATS[:month_year] = "%B %Y"
Date::DATE_FORMATS[:wday_long_ordinal] = lambda { |date|
  day_format = ActiveSupport::Inflector.ordinalize(date.day)
  date.strftime("%a #{day_format} %B, %Y") # => "April 25th, 2007"
}
Time::DATE_FORMATS[:time_of_day] = "%H:%M"
