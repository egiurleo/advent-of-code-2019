class Operation
  def initialize(memory, instruction_address, relative_base, modes)
    @memory = memory
    @instruction_address = instruction_address
    @relative_base = relative_base
  end

  def perform
    # TODO: implement
  end

  private

  def read(addr)
    @memory[addr] ? @memory[addr].to_i : 0
  end

  def write(addr, val)
    @memory[addr] = val.to_s
    nil
  end
end

# ----- Operations that take three params -----

class ThreeParamOperation < Operation
  def initialize(memory, instruction_address, relative_base, modes)
    super(memory, instruction_address, relative_base, modes)

    param1 = read(@instruction_address + 1)
    param2 = read(@instruction_address + 2)
    param3 = read(@instruction_address + 3)

    @param1 = case modes.first
    when 0
      read(param1)
    when 1
      param1
    when 2
      read(@relative_base + param1)
    end

    @param2 = case modes[1]
    when 0
      read(param2)
    when 1
      param2
    when 2
      read(@relative_base + param2)
    end

    @param3 = case modes[2]
    when 2
      param3 + @relative_base
    else
      param3
    end
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
  def initialize(memory, instruction_address, relative_base, modes)
    super(memory, instruction_address, relative_base, modes)

    param = read(@instruction_address + 1)

    @param = case modes.first
    when 0
      read(param)
    when 1
      param
    when 2
      read(@relative_base + param)
    end
  end

  def next_instruction
    @instruction_address + 2
  end
end

class Input < OneParamOperation
  def initialize(memory, instruction_address, relative_base, input, modes)
    super(memory, instruction_address, relative_base, modes)

    param = read(@instruction_address + 1)

    @param = case modes.first
    when 2
      @relative_base + param
    else
      param
    end
    @input = input
  end

  def perform
    write(@param, @input)
  end
end

class Output < OneParamOperation
  def perform
    return @param
  end
end

class AdjustRelativeBase < OneParamOperation
  def perform
    return @relative_base + @param
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
    @relative_base = 0
  end

  def input(input)
    @input.concat(input)
  end

  def output(num=1)
    @output.shift(num)
  end

  def run
    while @memory[@position] != '99' do
      op = @memory[@position] || '0'

      op, _, mode0, mode1, mode3 = op.split('').reverse

      op_classes = [
        Addition,
        Multiplication,
        Input,
        Output,
        JumpIfTrue,
        JumpIfFalse,
        LessThan,
        EqualTo,
        AdjustRelativeBase
      ]

      op_class = op_classes[op.to_i - 1]

      raise "Unrecognized op code: #{op}" if op_class.nil?

      if op_class == Input
        input = @input.shift

        unless input
          return
        end

        operation = op_class.new(@memory, @position, @relative_base, input, [mode0.to_i])
      else
        operation = op_class.new(@memory, @position, @relative_base, [mode0.to_i, mode1.to_i, mode3.to_i])
      end

      result = operation.perform

      if op_class == AdjustRelativeBase
        @relative_base = result
      elsif op_class == Output
        @output << result
      end

      @position = operation.next_instruction
    end

    @terminated = true if @memory[@position] == '99'
  end
end
