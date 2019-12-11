require_relative './intcode'
require 'byebug'

memory = File.read('11/input.txt').chomp.split(',')
robot = Intcode.new(memory)

current_position = [0, 0]
current_direction = 0
painted = {}

input = 1
while !robot.terminated
  robot.input([input])
  robot.run
  color = robot.output_one
  direction = robot.output_one

  painted[current_position] = color

  new_direction = direction == 0 ? current_direction - 90 : current_direction + 90
  new_direction = (new_direction + 360) % 360

  current_position = case new_direction
  when 0
    [current_position.first, current_position.last - 1]
  when 90
    [current_position.first + 1, current_position.last]
  when 180
    [current_position.first, current_position.last + 1]
  when 270
    [current_position.first - 1, current_position.last]
  else
    raise "Incorrect direction: #{new_direction}"
  end

  current_direction = new_direction
  input = painted[current_position] || 0
end

puts "The solution to part one is: #{painted.length}"

x_coords = painted.keys.map { |x,_| x }
y_coords = painted.keys.map { |_,y| y }

min_x = x_coords.min
max_x = x_coords.max
min_y = y_coords.min
max_y = y_coords.max

image = Array.new(max_y - min_y + 1)
image.each.with_index { |_, idx| image[idx] = Array.new(max_x - min_x + 1, ' ')}

painted.each do |coord, color|
  if color == 1
    begin
      image[coord.last - min_y][coord.first - min_x] = '@'
    end
  end
end

puts "The solution to part two is:"
image.each do |row|
  puts row.join('')
end

