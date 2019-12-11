require 'byebug'
require_relative './shared'

asteroids = []

# require '~/advent-of-code-2019/10/shared'
# a0 = Asteroid.new(0, 0)
# aup = Asteroid.new(0, -1)
# adiag1 = Asteroid.new(1, -1)
# aright = Asteroid.new(1, 0)
# adiag2 = Asteroid.new(1, 1)
# adown = Asteroid.new(0, 1)
# adiag3 = Asteroid.new(-1, 1)
# aleft = Asteroid.new(-1, 0)
# adiag4 = Asteroid.new(-1, -1)

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

solution = asteroids_in_order[199]
puts "The solution to part 2 is: #{(solution.x * 100) + solution.y }"

