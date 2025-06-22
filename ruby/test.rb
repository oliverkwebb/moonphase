#!/usr/bin/env ruby
require_relative 'moonphase'

# Test cases using the same timestamps as the Python version
test_cases = [
  { timestamp: -178070400, expected_percent: 1.2, description: "Test case 1" },
  { timestamp: 361411200, expected_percent: 93.6, description: "Test case 2" },
  { timestamp: 1704931200, expected_percent: 0.4, description: "Test case 3" },
  { timestamp: 2898374400, expected_percent: 44.2, description: "Test case 4" }
]

puts "Testing Ruby moonphase implementation:"
puts "=" * 50

test_cases.each_with_index do |test_case, index|
  date = Time.at(test_case[:timestamp]).utc
  
  # Calculate illuminated fraction and percentage
  fraction = illuminated_fraction(date)
  percent = illuminated_percent(date)
  
  puts "Test #{index + 1}: #{test_case[:description]}"
  puts "  Date: #{date}"
  puts "  Timestamp: #{test_case[:timestamp]}"
  puts "  Illuminated fraction: #{fraction.round(4)}"
  puts "  Illuminated percent: #{percent}%"
  puts "  Expected percent: #{test_case[:expected_percent]}%"
  
  # Check if the result matches expected value
  if percent == test_case[:expected_percent]
    puts "  ✓ PASS"
  else
    puts "  ✗ FAIL (expected #{test_case[:expected_percent]}%, got #{percent}%)"
  end
  puts
end

# Additional demonstration with current date
current_date = Time.now.utc
puts "Current moon phase (#{current_date}):"
puts "  Illuminated fraction: #{illuminated_fraction(current_date).round(4)}"
puts "  Illuminated percent: #{illuminated_percent(current_date)}%"