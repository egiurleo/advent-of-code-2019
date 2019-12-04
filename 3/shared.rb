# Given a starting point in the format [x, y]
# and a direction string in the format "R30"
# "<direction><distance>", find the point
# that is the correct direction/distance away
# from the starting point.
#
# For example, if start is [0, 0] and dir
# is "L3", this method would return [-3, 0].
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

# Given two points, return a list of all points
# in between those two points, including the
# points themselves.
#
# For example, if start was [0, 0] and finish was
# [2, 0], this method would return:
# [ [0, 0], [1, 0], [2, 0] ].
def points_in_between(start, finish)
  if start.first != finish.first && start.last != finish.last
    raise "Cannot return coordinates in between points not in a straight line."
  end

  if start.first == finish.first
    return (start.last..finish.last).to_a.map do |y|
      [start.first, y]
    end
  end

  if start.last == finish.last
    return (start.first..finish.first).to_a.map do |x|
      [x, start.last]
    end
  end
end

# Calculate the Manhattan distance between two points.
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

# Given a wire, which is an array of directions in the format
# "<direction><distance>" (e.g. "R30"), find all points touched
# by the wire as well as their distance from the central point
# along the wire.
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

      if !distances[point] || distances[point] < point_distance
        distances[point] = point_distance
      end
    end

    total_distance += manhattan_distance(curr_point, new_point)
    curr_point = new_point
  end

  distances
end

# Given a central point and a list of other points, find
# the minimum Manhattan distance from the central point
# to any of the other points.
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

# Given two hashes representing the distance from the central point
# for every point in a wire, as well as a list of points, find the
# minimum distance from the central point to any of the points along
# the two wires.
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
