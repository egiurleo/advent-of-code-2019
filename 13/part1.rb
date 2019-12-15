require_relative './intcode'
require 'byebug'

memory = File.read('13/input.txt').chomp.split(',')

class Game
  def initialize(memory, free: false)
    memory[0] = 2 if free
    @program = Intcode.new(memory)
    @grid = {}
  end

  def draw(x, y, item)
    @grid[[x, y]] = item
  end

  def play
    @program.run

    output = @program.output(3)
    while !output.empty? do
      byebug if output == [] || output == nil
      x, y, item = output
      draw(x, y, item)

      output = @program.output(3)
    end
  end

  def count(item)
    @grid.values.select { |val| val == item }.length
  end
end

game = Game.new(memory, free: true)
game.play
puts "The solution to part one is: #{game.count(2)}"


