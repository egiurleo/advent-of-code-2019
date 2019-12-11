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

    if delta_x > 0 || delta_x == 0 && delta_y > 0
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
  lines = {}

  asteroids.each do |asteroid2|
    next if asteroid1 == asteroid2

    line = asteroid1.line_to(asteroid2)

    lines[line] ||= {
      positive: {
        distance: Float::INFINITY,
        asteroid: nil
      },
      negative: {
        distance: Float::INFINITY,
        asteroid: nil
      }
    }

    direction = asteroid1.direction_to(asteroid2)
    distance = asteroid1.distance_to(asteroid2)

    if lines[line][direction][:asteroid] == nil ||
      lines[line][direction][:distance] > distance

      lines[line][direction][:asteroid] = asteroid2
      lines[line][direction][:distance] = distance
    end
  end

  num_asteroids = lines.map do |_, line|
    [line[:positive][:asteroid], line[:negative][:asteroid]]
  end.flatten.compact.uniq.count

  asteroids_in_line_of_sight[asteroid1] = num_asteroids
end

max = asteroids_in_line_of_sight.map do |asteroid, num|
  num
end.max

puts "The solution to part one is: #{max}"
