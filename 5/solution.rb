
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
# memory = [4, 3, 99, 100]

position = 0
while memory[position] != 99
  op = memory[position]

  case op
  when 1
    operation = Addition.new(memory, position)
  when 2
    operation = Multiplication.new(memory, position)
  when 3
    operation = Input.new(memory, position)
  when 4
    operation = Output.new(memory, position)
  else
    op_arr = op.to_s.split('').reverse

    if op_arr.first == '1'
      operation = Addition.new(memory, position, modes: [op_arr[2].to_i,  op_arr[3].to_i])
    elsif op_arr.first == '2'
      operation = Multiplication.new(memory, position, modes: [op_arr[2].to_i,  op_arr[3].to_i])
    elsif op_arr.first == '3'
      operation = Input.new(memory, position)
    elsif op_arr.first == '4'
      operation = Output.new(memory, position, mode: op_arr[2].to_i)
    else
      raise "Unrecognized op code: #{op_arr.first}"
    end
  end

  operation.perform
  # puts "memory: #{memory}"
  position += operation.skip
end
