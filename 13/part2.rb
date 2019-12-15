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
          '*'
        else
          raise "Invalid cell value: #{cell}"
        end

        char
      end
      puts draw.join('')
    end
  end

  def read_char
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
        extra_thread.join(0.00001)
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
        elsif input == "e"
          Thread.current[:output] = "xxx"
        end
      end

      t = input_thread.join(0.25)
      input_thread.kill
      if t.nil?
        @program.input([0])
      else
        output = input_thread[:output]
        break if output == "xxx"

        @program.input([output])
      end
    end
  end
end

game = Game.new(memory, free: true)
game.play

