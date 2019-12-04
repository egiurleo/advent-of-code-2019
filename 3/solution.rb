require_relative './shared'
require 'byebug'

input = File.read('3/input.txt').chomp
first_wire, second_wire = input.split("\n").map { |wire_str| wire_str.split(',') }

first_wire_distances = all_wire_distances(first_wire)
second_wire_distances = all_wire_distances(second_wire)

# first_wire_points = first_wire_distances.keys
# second_wire_points = second_wire_distances.keys

first_wire_points = all_wire_points(first_wire)
second_wire_points = all_wire_points(second_wire)

common_points = first_wire_points & second_wire_points

puts "The solution to part one is: #{min_manhattan_distance([0, 0], common_points)}"
puts "The solution to part two is: #{min_wire_distance(first_wire_distances, second_wire_distances, common_points)}"

