
class Moon
  attr_reader :position, :velocity

  def initialize(x, y, z)
    @position = [x, y, z]
    @velocity = [0, 0, 0]
  end

  def time_step(gravity_x, gravity_y, gravity_z)
    v_x, v_y, v_z = @velocity
    @velocity = [v_x + gravity_x, v_y + gravity_y, v_z + gravity_z]

    v_x, v_y, v_z = @velocity
    p_x, p_y, p_z = @position

    @position = [p_x + v_x, p_y + v_y, p_z + v_z]
  end

  def time_step_on_axis(axis, gravity)
    v = @velocity[axis]
    new_velocity = v + gravity

    @velocity[axis] = new_velocity

    pos = @position[axis]
    @position[axis] = pos + new_velocity
  end

  def potential_energy
    @position.map(&:abs).reduce(&:+)
  end

  def kinetic_energy
    @velocity.map(&:abs).reduce(&:+)
  end

  def energy
    potential_energy * kinetic_energy
  end
end

class SolarSystem
  attr_reader :moons

  def initialize(positions)
    @moons = positions.map { |position| Moon.new(*position) }
  end

  def time_step
    gravities = {}

    @moons.each do |moon1|
      gravity = [0, 0, 0]
      @moons.each do |moon2|
        next if moon1 == moon2

        moon1.position.each.with_index do |pos, idx|
          moon2_pos = moon2.position[idx]
          if moon2_pos > pos
            gravity[idx] += 1
          elsif moon2_pos < pos
            gravity[idx] -= 1
          end
        end
      end

      gravities[moon1] = gravity
    end

    @moons.each { |moon| moon.time_step(*gravities[moon]) }
  end

  def energy
    @moons.map(&:energy).reduce(&:+)
  end

  def state
    @moons.map { |moon| [moon.position, moon.velocity] }
  end
end
