require_relative './shared'

memory = File.read('5/input.txt').chomp.split(',').map(&:to_i)

position = 0
while memory[position] != 99
  op = memory[position]

  unless ['1', '2', '3', '4'].include?(op)
    op_arr = op.to_s.split('').reverse
    op = op_arr.first.to_i
    mode0 = op_arr[2].to_i
    mode1 = op_arr[3].to_i
  end

  mode0 = 0 if mode0.nil?
  mode1 = 0 if mode1.nil?

  operation = case op
  when 1
    Addition.new(memory, position, modes: [mode0, mode1])
  when 2
    Multiplication.new(memory, position, modes: [mode0, mode1])
  when 3
    Input.new(memory, position)
  when 4
    Output.new(memory, position, modes: [mode0])
  when 5
    JumpIfTrue.new(memory, position, modes: [mode0, mode1])
  when 6
    JumpIfFalse.new(memory, position, modes: [mode0, mode1])
  when 7
    LessThan.new(memory, position, modes: [mode0, mode1])
  when 8
    EqualTo.new(memory, position, modes: [mode0, mode1])
  else
    raise "Unrecognized op code: #{op_arr.first}"
  end

  operation.perform
  # puts "memory: #{memory}"
  position = operation.next_instruction
end

# 7161591