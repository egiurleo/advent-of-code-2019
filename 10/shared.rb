require 'byebug'

class Asteroid
  attr_reader :x, :y
  def initialize(x, y)
    @x = x.to_f
    @y = y.to_f
  end

  def quadrant_of(asteroid)
    delta_x = asteroid.x - x
    delta_y = asteroid.y - y

    if delta_x == 0 && delta_y < 0 || delta_x > 0 && delta_y < 0
      return :first
    elsif delta_x > 0 && delta_y == 0 || delta_x > 0 && delta_y > 0
      return :second
    elsif delta_x == 0 && delta_y > 0 || delta_x < 0 && delta_y > 0
      return :third
    else
      return :fourth
    end
  end

  def distance_to(asteroid)
    return Math.sqrt((asteroid.x - x)**2 + (asteroid.y - y)**2)
  end

  def angle_to(asteroid)
    delta_x = asteroid.x - x
    delta_y = asteroid.y - y

    mult = 180.0/Math::PI

    case quadrant_of(asteroid)
    when :first
      return mult * Math.atan(delta_x / (-1 * delta_y))
    when :second
      return 90 + (mult * Math.atan(delta_y/delta_x))
    when :third
      return 180 + (mult * Math.atan((-1 * delta_x) / delta_y))
    when :fourth
      return 270 + (mult * Math.atan((-1 * delta_y) / (-1 * delta_x)))
    end
  end
end
