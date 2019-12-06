
class Operation
  def initialize(memory, instruction_address)
    @memory = memory
    @instruction_address = instruction_address
  end

  def perform
    # TODO: implement
  end
end

class ThreeParamOperation < Operation
  def initialize(memory, instruction_address, modes: [0, 0])
    super(memory, instruction_address)

    param1 = @memory[@instruction_address + 1]
    param2 = @memory[@instruction_address + 2]

    @param1 = modes.first == 0 ? @memory[param1] : param1
    @param2 = modes.last == 0 ? @memory[param2] : param2

    @param3 = @memory[@instruction_address + 3]
  end

  def next_instruction
    @instruction_address + 4
  end
end

class OneParamOperation < Operation
  def next_instruction
    @instruction_address + 2
  end
end

class Addition < ThreeParamOperation
  def perform
    @memory[@param3] = @param1 + @param2
  end
end

class Multiplication < ThreeParamOperation
  def perform
    @memory[@param3] = @param1 * @param2
  end
end

class Input < OneParamOperation
  def initialize(memory, instruction_address)
    super(memory, instruction_address)
    @param = @memory[@instruction_address + 1]
  end

  def perform
    print 'Operation expects input: '
    result = gets.to_i

    @memory[@param] = result
  end
end

class Output < OneParamOperation
  def initialize(memory, instruction_address, modes: [0])
    super(memory, instruction_address)

    param = @memory[@instruction_address + 1]
    @param = modes.first == 0 ? @memory[param] : param
  end

  def perform
    puts "Program output: #{@param}"
  end
end

class JumpIfTrue < ThreeParamOperation
  def next_instruction
    @param1 == 0 ? @instruction_address + 3 : @param2
  end
end

class JumpIfFalse < ThreeParamOperation
  def next_instruction
    @param1 == 0 ? @param2 : @instruction_address + 3
  end
end

class LessThan < ThreeParamOperation
  def perform
    @memory[@param3] = @param1 < @param2 ? 1 : 0
  end
end

class EqualTo < ThreeParamOperation
  def perform
    @memory[@param3] = @param1 == @param2 ? 1 : 0
  end
end

require 'byebug'
memory = File.read('5/input.txt').chomp.split(',').map(&:to_i)

# memory = [1, 5, 6, 4, 0, 98, 1] # addition
# memory = [2, 5, 6, 4, 0, 33, 3] # multiplication
# memory = [3, 2, 0] # input
# memory = [4, 2, 99] # output

# memory = ['0001', 5, 6, 4, 0, 98, 1] # addition
# memory = ['01', 5, 6, 4, 0, 98, 1] # addition
# memory = ['1101', 98, 1, 4, 0] # addition

# memory = ['0002', 5, 6, 4, 0, 33, 3] # multiplication
# memory = ['02', 5, 6, 4, 0, 33, 3]
# memory = ['1102', 33, 3, 4, 0]

# memory = ['104', 6, 99]
# memory = ['004', 2, 99]
# memory = ['04', 2, 99]

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