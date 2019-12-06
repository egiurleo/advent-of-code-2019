require_relative './shared'
require 'byebug'

memory = File.read('5/input.txt').chomp.split(',')

position = 0
while memory[position] != '99' do
  op = memory[position]

  op, _, mode0, mode1 = op.split('').reverse

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

  op_class = op_classes[op.to_i - 1]

  raise "Unrecognized op code: #{op}" if op_class.nil?

  operation = op_class.new(memory, position, [mode0.to_i, mode1.to_i])

  operation.perform
  position = operation.next_instruction
end

# 7161591