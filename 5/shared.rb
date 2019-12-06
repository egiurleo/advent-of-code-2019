class Operation
  def initialize(memory, instruction_address, modes)
    @memory = memory
    @instruction_address = instruction_address
  end

  def perform
    # TODO: implement
  end
end

# ----- Operations that take three params -----

class ThreeParamOperation < Operation
  def initialize(memory, instruction_address, modes)
    super(memory, instruction_address, modes)

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

# ----- Operations that take one param -----

class OneParamOperation < Operation
  def next_instruction
    @instruction_address + 2
  end
end

class Input < OneParamOperation
  def initialize(memory, instruction_address, modes)
    super(memory, instruction_address, modes)
    @param = @memory[@instruction_address + 1]
  end

  def perform
    print 'Operation expects input: '
    result = gets.to_i

    @memory[@param] = result
  end
end

class Output < OneParamOperation
  def initialize(memory, instruction_address, modes)
    super(memory, instruction_address, modes)

    param = @memory[@instruction_address + 1]
    @param = modes.first == 0 ? @memory[param] : param
  end

  def perform
    puts "Program output: #{@param}"
  end
end