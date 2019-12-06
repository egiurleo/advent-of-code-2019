
class Operation
  def initialize(memory, instruction_address)
    @memory = memory
    @instruction_address = instruction_address
  end

  def perform
    # TODO: implement
  end
end

class Addition < Operation
  def initialize(memory, instruction_address, modes: [0, 0])
    super(memory, instruction_address)

    param1 = @memory[@instruction_address + 1]
    param2 = @memory[@instruction_address + 2]

    @addend1 = modes.first == 0 ? @memory[param1] : param1
    @addend2 = modes.last == 0 ? @memory[param2] : param2

    @result_address = memory[@instruction_address + 3]
  end

  def perform
    @memory[@result_address] = @addend1 + @addend2
  end

  def skip
    4
  end
end

class Multiplication < Operation
  def initialize(memory, instruction_address, modes: [0, 0])
    super(memory, instruction_address)

    param1 = @memory[@instruction_address + 1]
    param2 = @memory[@instruction_address + 2]

    @factor1 = modes.first == 0 ? @memory[param1] : param1
    @factor2 = modes.last == 0 ? @memory[param2] : param2

    @result_address = @memory[@instruction_address + 3]
  end

  def perform
    @memory[@result_address] = @factor1 * @factor2
  end

  def skip
    4
  end
end

class Input < Operation
  def initialize(memory, instruction_address)
    super(memory, instruction_address)

    @result_address = memory[@instruction_address + 1]
  end

  def perform
    puts 'Operation expects input: '

    result = gets.to_i

    # puts "Inputting #{result} at position #{@result_address}"
    # puts "Previous value was: #{@memory[@result_address]}"
    @memory[@result_address] = result
    # puts "New value is: #{@memory[@result_address]}"
  end

  def skip
    2
  end
end

class Output < Operation
  def initialize(memory, instruction_address, mode: 0)
    super(memory, instruction_address)

    param = @memory[@instruction_address + 1]
    @output = mode == 0 ? @memory[param] : param
  end

  def perform
    puts "Program output: #{@output}"
  end

  def skip
    2
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

  unless ['1','2', '3', '4'].include?(op)
    op_arr = op.to_s.split('').reverse
    op = op_arr.first.to_i
    mode0 = op_arr[2].to_i
    mode1 = op_arr[3].to_i
  end

  mode0 = 0 unless mode0
  mode1 = 0 unless mode1

  case op
  when 1
    operation = Addition.new(memory, position, modes: [mode0, mode1])
  when 2
    operation = Multiplication.new(memory, position, modes: [mode0, mode1])
  when 3
    operation = Input.new(memory, position)
  when 4
    operation = Output.new(memory, position, mode: mode0)
  else
    raise "Unrecognized op code: #{op_arr.first}"
  end

  operation.perform
  # puts "memory: #{memory}"
  position += operation.skip
end
