require_relative './moon'
require 'byebug'

# real input:
positions = [[13, 9, 5], [8, 14, -2], [-5, 4, 11], [2, -6, 1]]

# positions = [[-1, 0, 2], [2, -10, -7], [4, -8, 8], [3, 5, -1]]

# positions = [[-8, -10, 0], [5, 5, 10], [2, -7, 3], [9, -8, -3]]

system = SolarSystem.new(positions)

1000.times do |_|
  system.time_step
end

puts "The solution to part one is: #{system.energy}"

# states = {}
# state = system.time_step
# i = 1

# while !states[state] do
#   state = system.time_step
#   i += 1
# end

# puts "The solution to part two is: #{i}"
