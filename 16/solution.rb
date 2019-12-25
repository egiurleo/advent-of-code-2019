require 'byebug'

class FFT
  PATTERN = [0, 1, 0, -1]
  attr_reader :signal

  def initialize(signal, part_two: false)
    if part_two
      @offset = signal.first(7).join('').to_i

      signal_offset = @offset % signal.length
      repetitions = 10000 - (@offset.to_f / signal.length.to_f).ceil
      @signal = signal[signal_offset..] + signal * repetitions
    else
      @signal = signal
      @patterns = build_patterns
    end
  end

  def response
    @signal.first(8).join('')
  end

  def part_two_phase
    new_signal = []

    @signal.length.times do |idx|
      sum = new_signal.last || 0
      new_dig = (sum + @signal[-1 * (idx + 1)])%10

      new_signal << new_dig
    end

    @signal = new_signal.reverse
  end

  def part_two_response
    # @signal[@offset..@offset + 8].join('')
    @signal.first(8).join('')
  end

  def phase
    new_signal = []

    @signal.length.times do |idx|
      pattern = @patterns[idx]

      num = @signal.map.with_index do |sig, j|
        sig * pattern[j]
      end

      new_signal << num.reduce(&:+) % 10
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
# signal = '03036732577212944063491565474664'

fft = FFT.new(signal.split('').map(&:to_i))

100.times do
  fft.phase
end

puts "The solution to part one is: #{fft.response}"

fft2 = FFT.new(signal.split('').map(&:to_i), part_two: true)

100.times do |i|
  fft2.part_two_phase
end

puts "The solution to part two is: #{fft2.part_two_response}"
