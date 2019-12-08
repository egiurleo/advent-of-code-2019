class Operation
  def initialize(memory, instruction_address, modes)
    @memory = memory
    @instruction_address = instruction_address
  end

  def perform
    # TODO: implement
  end

  private

  def read(addr)
    @memory[addr].to_i
  end

  def write(addr, val)
    @memory[addr] = val.to_s
    nil
  end
end

# ----- Operations that take three params -----

class ThreeParamOperation < Operation
  def initialize(memory, instruction_address, modes)
    super(memory, instruction_address, modes)

    param1 = read(@instruction_address + 1)
    param2 = read(@instruction_address + 2)

    @param1 = modes.first == 0 ? read(param1) : param1
    @param2 = modes.last == 0 ? read(param2) : param2

    @param3 = read(@instruction_address + 3)
  end

  def next_instruction
    @instruction_address + 4
  end
end

class Addition < ThreeParamOperation
  def perform
    write(@param3, @param1 + @param2)
  end
end

class Multiplication < ThreeParamOperation
  def perform
    write(@param3, @param1 * @param2)
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
    val = @param1 < @param2 ? 1 : 0
    write(@param3, val)
  end
end

class EqualTo < ThreeParamOperation
  def perform
    val = @param1 == @param2 ? 1 : 0
    write(@param3, val)
  end
end

# ----- Operations that take one param -----

class OneParamOperation < Operation
  def next_instruction
    @instruction_address + 2
  end
end

class Input < OneParamOperation
  def initialize(memory, instruction_address, input, modes)
    super(memory, instruction_address, modes)

    @input = input
    @param = read(@instruction_address + 1)
  end

  def perform
    # print "Operation expects input: #{@input}"
    # result = gets.chomp

    write(@param, @input)
  end
end

class Output < OneParamOperation
  def initialize(memory, instruction_address, modes)
    super(memory, instruction_address, modes)

    param = read(@instruction_address + 1)
    @param = modes.first == 0 ? read(param) : param
  end

  def perform
    return @param
    # puts "Program output: #{@param}"
  end
end

class Intcode
  attr_reader :terminated

  def initialize(memory)
    @memory = memory.dup
    @input = []
    @output = []
    @position = 0
    @terminated = false
  end

  def input(input)
    @input.concat(input)
  end

  def output
    @output.shift
  end

  def run
    while @memory[@position] != '99' do
      op = @memory[@position]

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

      if op_class == Input
        input = @input.shift

        unless input
          return
        end

        operation = op_class.new(@memory, @position, input, [mode0.to_i, mode1.to_i])
      else
        operation = op_class.new(@memory, @position, [mode0.to_i, mode1.to_i])
      end

      result = operation.perform

      @output << result if result
      @position = operation.next_instruction
    end

    @terminated = true if @memory[@position] == '99'
  end
end