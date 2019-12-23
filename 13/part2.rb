require_relative './intcode'
require 'byebug'

memory = File.read('13/input.txt').chomp.split(',')

class Game
  attr_reader :program

  HEIGHT = 23
  WIDTH = 36
  def initialize(memory, position: 0, free: false, relative_base: relative_base, grid: grid, score: score)
    memory = memory.dup
    memory[0] = '2' if free

    @program = Intcode.new(memory, position: position, relative_base: relative_base)
    @program.input([0])

    @grid = grid || Array.new(HEIGHT) { |_| Array.new(WIDTH) }
    @score = score
  end

  def draw
    system "stty gfmt1:cflag=4b00:iflag=2b02:lflag=200005cb:oflag=3:discard=f:dsusp=19:eof=4:eol=ff:eol2=ff:erase=7f:intr=3:kill=15:lnext=16:min=1:quit=1c:reprint=12:start=11:status=14:stop=13:susp=1a:time=0:werase=17:ispeed=38400:ospeed=38400"
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
          'T'
        when 4
          "\e[35m*\e[0m"
        else
          raise "Invalid cell value: #{cell}"
        end

        char
      end
      puts draw.join('')
    end
  end

  def read_char
    # From: http://www.alecjacobson.com/weblog/?p=75
    begin
      # save previous state of stty
      old_state = `stty -g`
      # disable echoing and enable raw (not having to press enter)
      system "stty raw -echo"
      c = STDIN.getc.chr
      # gather next two characters of special keys
      if(c=="\e")
        extra_thread = Thread.new{
          c = c + STDIN.getc.chr
          c = c + STDIN.getc.chr
        }
        # wait just long enough for special keys to get swallowed
        extra_thread.join(0.0001)
        # kill thread so not-so-long special keys don't wait on getc
        extra_thread.kill
      end
    rescue => ex
      puts "#{ex.class}: #{ex.message}"
      puts ex.backtrace
    ensure
      # restore previous state of stty
      system "stty #{old_state}"
    end
    return c
  end

  def play
    while !@program.terminated
      @program.run

      output = @program.output(3)
      while !output.empty? do
        x, y, item = output

        if x == -1 && y == 0
          @score = item
          puts "NEW SCORE: #{@score}"
        else
          @grid[y][x] = item
        end

        output = @program.output(3)
      end

      draw

      input_thread = Thread.new do
        input = read_char
        if input == "\e[C"
          Thread.current[:output] = 1
        elsif input == "\e[D"
          Thread.current[:output] = -1
        elsif input == "s" || input == "e"
          Thread.current[:output] = input
        end
      end

      t = input_thread.join(0.35)
      input_thread.kill
      if t.nil?
        @program.input([0])
      else
        output = input_thread[:output]
        break if output == "e"
        save_game if output == "s"

        @program.input([output])
      end
    end
  end

  def self.from_saved
    position = nil
    score = nil
    memory = nil

    lines = File.read('13/saved_game.txt').split("\n").map(&:chomp)

    position = lines.shift.chomp
    memory = lines.shift.chomp
    relative_base = lines.shift.chomp
    score = lines.shift.chomp.to_i

    grid = lines.map { |line| line.split(',').map(&:to_i) }

    self.new(memory.split(','), position: position.to_i, relative_base: relative_base, grid: grid, score: score)
  end

  private

  def save_game
    File.open('13/saved_game.txt', 'w') do |file|
      file.write("#{@program.position}\n")
      file.write("#{@program.memory.join(',')}\n")
      file.write("#{@program.relative_base}\n")
      file.write("#{@score}\n")

      @grid.each do |row|
        file.write("#{row.join(',')}\n")
      end
    end
  end
end

print "Play from saved? [y/n] "
input = gets.chomp

if input == "n"
  game = Game.new(memory, free: true)
else
  game = Game.from_saved
end

game.play

