require_relative './intcode.rb'
require 'byebug'

memory = File.read('15/input.txt').chomp.split(',')

class Droid
  def initialize(memory)
    @program = Incode.new(memory)
    @current_position = [0, 0]
  end

  def find_oxygen
   
  end

  private

  # ----- EXPLORE -----
  def explore_north
    output = move_north
    move_south
    output
  end

  def explore_south
    output = move_south
    move_north
    output
  end

  def explore_east
    output = move_east
    move_west
    output
  end

  def explore_west
    output = move_west
    move_east
    output
  end

  # ----- MOVE -----
  def move_north
    @program.input([1])
    @program.run

    @program.output
  end

  def move_south
    @program.input([2])
    @program.run

    @program.output
  end

  def move_west
    @program.input([3])
    @program.run

    @program.output
  end

  def move_east
    @program.input([4])
    @program.run

    @program.output
  end
end
