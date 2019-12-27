require_relative './intcode'
require 'byebug'

class ASCII
  def initialize(memory, new_rules: false)
    memory[0] = '2' if new_rules
    @program = Intcode.new(memory)
  end

  def output
    @program.run
    @grid = [[]]

    while output = @program.output.first do
      if output == 10
        @grid << []
      else
        @grid.last << output.chr
      end
    end
  end

  def print_grid
    @grid.each do |row|
      puts row.join('')
    end
  end

  def find_intersections
    intersections = []

    (0..@grid.length - 1).to_a.each do |i|
      (0..@grid.first.length - 1).to_a.each do |j|
        is_intersection =
          @grid[i][j] == '#' &&
          @grid[i + 1][j] == '#' &&
          @grid[i - 1][j] == '#' &&
          @grid[i][j + 1] == '#' &&
          @grid[i][j - 1] == '#'

        intersections << [i, j] if is_intersection
      end
    end

    intersections
  end
end

memory = File.read('17/input.txt').chomp.split(',')

ascii = ASCII.new(memory)
ascii.output
ascii.print_grid
intersections = ascii.find_intersections

puts "The solution to part one is: #{intersections.map do |i| i.first * i.last end.reduce(&:+)}"

ascii = ASCII.new(memory, new_rules: true)
