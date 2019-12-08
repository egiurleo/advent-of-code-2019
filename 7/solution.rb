require_relative './intcode.rb'
require 'byebug'

def all_permutations(arr)
  return [arr] if arr.length == 1

  permutations = []

  arr.each do |el|
    arr_dup = arr.dup
    arr_dup.delete(el)

    all_permutations(arr_dup).each do |permutation|
      permutations << [el].concat(permutation)
    end
  end

  return permutations
end

memory = File.read('7/test_input.txt').chomp.split(',')

# inputs = (0..4).to_a

# max_thrust = 0

# all_permutations(inputs).each do |input|
#   second_input = 0
#   5.times do |x|
#     second_input = run_program(memory, [input[x], second_input])
#   end

#   max_thrust = second_input if second_input > max_thrust
# end

# puts "The solution to part one is: #{max_thrust}"

inputs = (5..9).to_a
max_thrust = 0

input = [9, 8, 7, 6, 5]

result, halted = run_program(memory, [9, 0])
i = 1
while !halted do
  result, halted = run_program(memory, [input[i]].concat(result))
  i = i == 4 ? 0 : i + 1
end

puts "#{result}"
