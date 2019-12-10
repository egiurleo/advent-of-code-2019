require_relative './amplifier.rb'
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

memory = File.read('7/input.txt').chomp.split(',')

part_one_inputs = (0..4).to_a
part_one_solution = all_permutations(part_one_inputs)
                      .map do |input|
                        amplifier = Amplifier.new(input, memory)
                        amplifier.run_once
                      end.max

puts "The solution to part one is: #{part_one_solution}"

part_two_inputs = (5..9).to_a

part_two_solution = all_permutations(part_two_inputs)
                      .map do |input|
                        amplifier = Amplifier.new(input, memory)
                        amplifier.feedback_loop
                      end.max

puts "The solution to part two is: #{part_two_solution}"
