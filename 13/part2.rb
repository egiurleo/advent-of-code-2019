require_relative './intcode'
require 'byebug'

memory = File.read('13/input.txt').chomp.split(',')

class Game
  HEIGHT = 30
  WIDTH = 50
  def initialize(memory, free: false)
    memory = memory.dup
    memory[0] = '2' if free

    @program = Intcode.new(memory)
    @program.input([0])

    @grid = Array.new(HEIGHT) { |_| Array.new(WIDTH) }
    @score = 0
  end

  def draw
    puts "***** SCORE: #{@score} *****"
    @grid.each do |col|
      draw = col.map do |cell|
        char = case cell
        when 0,nil
          ' '
        when 1
          '|'
        when 2
          '#'
        when 3
          '_'
        when 4
          '*'
        else
          raise "Invalid cell value: #{cell}"
        end

        char
      end
      puts draw.join('')
    end
  end

  def play
    while !@program.terminated
      @program.run

      output = @program.output(3)
      while !output.empty? do
        x, y, item = output

        if x == -1 && y == 0
          @score = item
        else
          byebug if y >= HEIGHT || x >= WIDTH
          if item == 3
            # @grid[@paddle_pos.first][@paddle_pos.last] = nil if @paddle_pos
            # @paddle_pos = [y, x]
          elsif item == 4
            # byebug
            # @grid[@ball_pos.first][@ball_pos.last] = nil if @ball_pos
            # @grid[x][y] = nil if @grid[x][y] == 2
            # @ball_pos = [y, x]
          end
          @grid[y][x] = item
        end

        output = @program.output(3)
      end

      draw
      input = nil

      print "Joystick direction: "

      while !['j', 'k', 'l'].include?(input)
        input = gets.chomp

        program_input = case input
        when 'j'
          -1
        when 'k'
          0
        when 'l'
          1
        else
          print "Invalid program input. Try again: "
        end

        @program.input([program_input])
      end
    end
  end
end

game = Game.new(memory, free: true)
game.play

