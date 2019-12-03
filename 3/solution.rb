
require 'byebug'

def point_from_direction(start, dir)
  dir_arr = dir.split('')
  direction = dir_arr.shift
  distance = dir_arr.join('').to_i

  case direction
  when 'U'
    return [start.first, start.last - distance]
  when 'D'
    return [start.first, start.last + distance]
  when 'L'
    return [start.first - distance, start.last]
  when 'R'
    return [start.first + distance, start.last]
  else
    raise "Found invalid direction: #{direction}"
  end
end

def points_in_between(start, finish)
  if start.first != finish.first && start.last != finish.last
    raise "Cannot return coordinates in between points not in a straight line."
  end

  if start.first == finish.first
    lower, higher = start.last, finish.last if start.last < finish.last
    lower, higher = finish.last, start.last if finish.last < start.last

    return (lower..higher).to_a.map do |y|
      [start.first, y]
    end
  end

  if start.last == finish.last
    lower, higher = start.first, finish.first if start.first < finish.first
    lower, higher = finish.first, start.first if finish.first < start.first

    return (lower..higher).to_a.map do |x|
      [x, start.last]
    end
  end
end

def manhattan_distance(start, finish)
  (start.first - finish.first).abs + (start.last - finish.last).abs
end

def all_wire_points(wire)
  wire = wire.dup
  curr_point = [0, 0]

  wire_points = []

  while wire.length > 0
    new_point = point_from_direction(curr_point, wire.shift)
    points_in_between = points_in_between(curr_point, new_point)
    wire_points.concat(points_in_between)

    curr_point = new_point
  end

  return wire_points.uniq
end

def all_wire_distances(wire)
  wire = wire.dup
  curr_point = [0, 0]

  distances = {}
  total_distance = 0

  while wire.length > 0
    new_point = point_from_direction(curr_point, wire.shift)
    points_in_between = points_in_between(curr_point, new_point)

    points_in_between.each do |point|
      point_distance = total_distance + manhattan_distance(curr_point, point)
      if (distances[point] && point_distance < distances[point]) || !distances[point]
        distances[point] = point_distance
      end
    end

    total_distance += manhattan_distance(curr_point, new_point)
    curr_point = new_point
  end

  distances
end

def min_manhattan_distance(central_point, points)
  min_manhattan_distance = Float::INFINITY

  points.each do |point|
    distance = manhattan_distance(point, central_point)
    if distance < min_manhattan_distance && distance != 0
      min_manhattan_distance = distance
    end
  end

  min_manhattan_distance
end

def min_wire_distance(first_wire_distances, second_wire_distances, points)
  min_wire_distance = Float::INFINITY

  points.each do |point|
    distance = first_wire_distances[point] + second_wire_distances[point]
    if distance < min_wire_distance && distance != 0
      min_wire_distance = distance
    end
  end

  min_wire_distance
end

input = File.read('3/input.txt').chomp
first_wire, second_wire = input.split("\n").map { |wire_str| wire_str.split(',') }

first_wire_points = all_wire_points(first_wire)
second_wire_points = all_wire_points(second_wire)

common_points = first_wire_points & second_wire_points

puts "The solution to part one is: #{min_manhattan_distance([0, 0], common_points)}"

first_wire_distances = all_wire_distances(first_wire)
second_wire_distances = all_wire_distances(second_wire)

puts "The solution to part two is: #{min_wire_distance(first_wire_distances, second_wire_distances, common_points)}"

