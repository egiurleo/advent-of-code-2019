require 'byebug'

class FFT
  PATTERN = [0, 1, 0, -1]
  attr_reader :signal

  def initialize(signal, part_two: false)
    @signal = signal
    @patterns = build_patterns

    if part_two
      @signal = @signal*1000
      @offset = @signal.first(7).map(&:to_s).join('').to_i
    end
  end

  def phase
    new_signal = []

    @signal.length.times do |idx|
      pattern = @patterns[idx]

      num = @signal.map.with_index do |sig, j|
        sig * pattern[j]
      end

      new_signal << num.reduce(&:+).to_s.split('').last.to_i
    end

    @signal = new_signal
  end

  private

  def build_patterns
    @signal.map.with_index do |_, idx|
      pattern = []

      i = 0
      while pattern.length < @signal.length + 1
        pattern.concat(Array.new(idx + 1, PATTERN[i]))
        i == PATTERN.length - 1 ? i = 0 : i += 1
      end

      pattern.shift
      pattern.first(@signal.length)
    end
  end
end

signal = File.read('16/input.txt').chomp
# signal = '12345678'

fft = FFT.new(signal.split('').map(&:to_i))

100.times do
  fft.phase
end

puts "The solution to part one is: #{fft.signal.first(8).join('')}"
