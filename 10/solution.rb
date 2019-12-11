require 'byebug'

class Asteroid
  attr_reader :x, :y
  def initialize(x, y)
    @x = x.to_f
    @y = y.to_f
  end

  def direction_to(asteroid)
    delta_x = asteroid.x - x
    delta_y = asteroid.y - y

    if delta_x > 0 || delta_x == 0 && delta_y < 0
      return :positive
    else
      return :negative
    end
  end

  def distance_to(asteroid)
    return Math.sqrt((asteroid.x - x)**2 + (asteroid.y - y)**2)
  end

  def line_to(asteroid)
    slope = ((asteroid.y - y)/(asteroid.x - x))
    intercept = y - (slope * x)

    [slope, intercept]
  end

  def angle_to(asteroid)
    base = ((180.0/Math::PI) * Math.atan((asteroid.y - y)/(asteroid.x - x)))

    if direction_to(asteroid) == :positive
      return 90 + base
    else
      return 270 + base
    end
  end
end

asteroids = []

File.open('10/input.txt').each.with_index do |line, y|
  cells = line.chomp.split('')

  cells.each.with_index do |cell, x|
    asteroids << Asteroid.new(x, y) if cell == '#'
  end
end

asteroids_in_line_of_sight = {}

asteroids.each do |asteroid1|
  angles = {}

  asteroids.each do |asteroid2|
    next if asteroid1 == asteroid2

    angle = asteroid1.angle_to(asteroid2)
    angles[angle] ||= []
    angles[angle] << asteroid2
  end

  asteroids_in_line_of_sight[asteroid1] = angles.length
end

max_num_asteroids = -1 * Float::INFINITY
asteroid = nil

asteroids_in_line_of_sight.each do |a, num|
  if num > max_num_asteroids
    max_num_asteroids = num
    asteroid = a
  end
end

puts "The solution to part one is: #{max_num_asteroids}"

angles = {}

asteroids.each do |asteroid2|
  next if asteroid == asteroid2

  angle = asteroid.angle_to(asteroid2)

  angles[angle] ||= []
  angles[angle] << asteroid2
end

asteroids_by_angle = angles.sort.map do |_, asteroids|
  asteroids.sort_by { |asteroid2| asteroid.distance_to(asteroid2) }
end

asteroids_in_order = []
while asteroids_by_angle.length > 0 do
  asteroids_by_angle.each do |as|
    asteroids_in_order << as.shift
  end

  asteroids_by_angle = asteroids_by_angle.select { |as| !as.empty? }
end

# asteroids_to_print = asteroids_in_order.map { |a| [a.x, a.y, asteroid.angle_to(a)] }
# asteroids_to_print.each.with_index do |atp, idx| puts "#{idx + 1}. #{atp.inspect}" end

solution = asteroids_in_order[199]
byebug
puts "The solution to part 2 is: #{(solution.x * 100) + solution.y }"

