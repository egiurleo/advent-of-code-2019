require_relative './shared'

memory = File.read('5/input.txt').chomp.split(',').map(&:to_i)

position = 0
while memory[position] != 99
  op = memory[position]

  unless ['1', '2', '3', '4'].include?(op)
    op, _, mode0, mode1 = op.to_s.split('').reverse.map(&:to_i)
  end

  mode0 = 0 if mode0.nil?
  mode1 = 0 if mode1.nil?

  op_classes = [
    Addition,
    Multiplication,
    Input,
    Output,
    JumpIfTrue,
    JumpIfFalse,
    LessThan,
    EqualTo
  ]

  op_class = op_classes[op - 1]

  raise "Unrecognized op code: #{op}" if op_class.nil?

  operation = op_class.new(memory, position, [mode0, mode1])
  operation.perform
  position = operation.next_instruction
end

# 7161591