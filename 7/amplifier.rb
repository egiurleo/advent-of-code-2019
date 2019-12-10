require_relative './intcode'

class Amplifier
  def initialize(program_code, memory)
    @programs = [
      Intcode.new(memory),
      Intcode.new(memory),
      Intcode.new(memory),
      Intcode.new(memory),
      Intcode.new(memory)
    ]

    program_code.each.with_index do |code, idx|
      @programs[idx].input([code])
    end
  end

  def run_once
    input = 0

    @programs.each.with_index do |program, idx|
      program.input([input])
      program.run
      input = program.output
    end

    input
  end

  def feedback_loop
    i = 0
    input = 0
    program = @programs.first

    while !program.terminated do
      program.input([input])

      program.run
      input = program.output

      i = i == @programs.length - 1 ? 0 : i + 1
      program = @programs[i]
    end

    input
  end
end