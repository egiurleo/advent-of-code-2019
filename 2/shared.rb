def run_intcode(noun, verb)
  memory = File.read('2/input.txt').chomp.split(',').map(&:to_i)

  memory[1] = noun
  memory[2] = verb

  curr_address = 0
  while memory[curr_address] != 99
    param1 = memory[curr_address + 1]
    param2 = memory[curr_address + 2]
    param3 = memory[curr_address + 3]

    val1 = memory[param1]
    val2 = memory[param2]

    if memory[curr_address] == 1
      memory[param3] = val1 + val2
    elsif memory[curr_address] == 2
      memory[param3] = val1 * val2
    else
      raise "Invalid opcode #{memory[curr_address]} found at position #{curr_address}."
    end

    curr_address += 4
  end

  memory.first
end
