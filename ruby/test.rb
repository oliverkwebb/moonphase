#!/usr/bin/env ruby
require_relative 'moonphase'

def illuminated_fraction(date)
  (1 - Math.cos(moonphase(date))) / 2
end

def illuminated_percent(date)
  (illuminated_fraction(date) * 100).round(1)
end

# Test cases using the same timestamps as the Python version
test_cases = [
  { timestamp: -178070400, expected_percent: 1.2},
  { timestamp: 361411200, expected_percent: 93.6},
  { timestamp: 1704931200, expected_percent: 0.4},
  { timestamp: 2898374400, expected_percent: 44.2}
]

test_cases.each_with_index do |test_case, index|
  date = Time.at(test_case[:timestamp]).utc

  # Calculate illuminated fraction and percentage
  fraction = illuminated_fraction(date)
  percent = illuminated_percent(date)

  print "expecting #{test_case[:expected_percent]}% at #{date}: "

  # Check if the result matches expected value
  if percent == test_case[:expected_percent]
    puts "PASS"
  else
    puts "FAIL (got #{percent}%)"
  end
end

puts "=" * 50
# Additional demonstration with current date
current_date = Time.now.utc
puts "Current moon phase (#{current_date}): #{illuminated_fraction(current_date).round(4)} (#{illuminated_percent(current_date)}%)"