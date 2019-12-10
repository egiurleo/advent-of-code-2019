require 'byebug'

pixels = File.read('8/input.txt').chomp.split('').map(&:to_i)

layer_width = 25
layer_height = 6

def create_layer(pixels, width, height)
  layer = []

  height.times do
    layer << pixels.shift(width)
  end

  layer
end

def visible_pixel(layers, height, width)
  layers.each do |layer|
    pixel = layer[height][width]
    return pixel if pixel != 2
  end

  return 2
end

def print_image(image)
  image.each do |row|
    img_row = row.map do |cell|
      cell == 0 ? ' ' : '@'
    end

    puts img_row.join(' ')
  end
end

def num_digits(layer, digit)
  layer.map do |row|
    row.select { |cell| cell == digit }
  end.flatten.length
end

layers = []
while pixels.length > 0
  layers << create_layer(pixels, layer_width, layer_height)
end

smallest_num_zeros = Float::INFINITY
smallest_num_zeros_layer = nil

layers.each.with_index do |layer, layer_num|
  num_zeros = num_digits(layer, 0)
  if num_zeros < smallest_num_zeros
    smallest_num_zeros = num_zeros
    smallest_num_zeros_layer = layer_num
  end
end

layer = layers[smallest_num_zeros_layer]

num_ones = num_digits(layer, 1)
num_twos = num_digits(layer, 2)

puts "The solution to part one is: #{num_ones * num_twos}"

final_image = Array.new(layer_height)
final_image.each.with_index { |_, idx| final_image[idx] = Array.new(layer_width)}

for i in (0..final_image.length - 1).to_a do
  for j in (0..final_image[i].length - 1).to_a do
    final_image[i][j] = visible_pixel(layers, i, j)
  end
end

puts "The solution to part two is:"
print_image(final_image)
