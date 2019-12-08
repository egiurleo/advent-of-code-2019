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

    @program_code = program_code
  end

  def run_once
    input = 0

    @programs.each.with_index do |program, idx|
      program.input([@program_code[idx], input])
      program.run
      input = program.output
    end

    input
  end

  def feedback_loop
    @program_code.each.with_index do |code, idx|
      @programs[idx].input([code])
    end

    i = 0
    input = 0
    program = @programs.first

    while !program.terminated do
      program.input([input])

      program.run
      input = program.output

      i = i == 4 ? 0 : i + 1
      program = @programs[i]
    end

    input
  end
end