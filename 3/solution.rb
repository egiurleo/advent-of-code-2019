require_relative './shared'

input = File.read('3/input.txt').chomp
first_wire, second_wire = input.split("\n").map { |wire_str| wire_str.split(',') }

first_wire_distances = all_wire_distances(first_wire)
second_wire_distances = all_wire_distances(second_wire)

first_wire_points = first_wire_distances.keys
second_wire_points = second_wire_distances.keys

common_points = first_wire_points & second_wire_points

###
# PART ONE:
#
# Opening the front panel reveals a jumble of wires. Specifically, two wires are connected to a central port and extend outward on a grid. You trace the path each wire takes as it leaves the central port, one wire per line of text (your puzzle input).
# The wires twist and turn, but the two wires occasionally cross paths. To fix the circuit, you need to find the intersection point closest to the central port. Because the wires are on a grid, use the Manhattan distance for this measurement. While the wires do technically cross right at the central port where they both start, this point does not count, nor does a wire count as crossing with itself.
# What is the Manhattan distance from the central port to the closest intersection?
###

puts "The solution to part one is: #{min_manhattan_distance([0, 0], common_points)}"

###
# PART TWO:
#
# It turns out that this circuit is very timing-sensitive; you actually need to minimize the signal delay.
# To do this, calculate the number of steps each wire takes to reach each intersection; choose the intersection where the sum of both wires' steps is lowest. If a wire visits a position on the grid multiple times, use the steps value from the first time it visits that position when calculating the total value of a specific intersection.
# The number of steps a wire takes is the total number of grid squares the wire has entered to get to that location, including the intersection being considered.
# What is the fewest combined steps the wires must take to reach an intersection?
###

puts "The solution to part two is: #{min_wire_distance(first_wire_distances, second_wire_distances, common_points)}"

