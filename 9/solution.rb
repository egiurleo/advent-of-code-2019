require_relative './intcode.rb'
require 'byebug'

memory = File.read('9/input.txt').chomp.split(',')

program = Intcode.new(memory)
program.input([1])
program.run

puts "Program output: #{program.output.inspect}"
