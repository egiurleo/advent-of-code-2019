###
# PART ONE
#
# An Intcode program is a list of integers separated by commas (like 1,0,0,3,99). To run one, start by looking at the first integer (called position 0). Here, you will find an opcode - either 1, 2, or 99. The opcode indicates what to do; for example, 99 means that the program is finished and should immediately halt. Encountering an unknown opcode means something went wrong.
#
# Opcode 1 adds together numbers read from two positions and stores the result in a third position. The three integers immediately after the opcode tell you these three positions - the first two indicate the positions from which you should read the input values, and the third indicates the position at which the output should be stored.
#
# Opcode 2 works exactly like opcode 1, except it multiplies the two inputs instead of adding them. Again, the three integers after the opcode indicate where the inputs and outputs are, not their values.
#
# Once you're done processing an opcode, move to the next one by stepping forward 4 positions.
#
# Once you have a working computer, the first step is to restore the gravity assist program (your puzzle input) to the "1202 program alarm" state it had just before the last computer caught fire. To do this, before running the program, replace position 1 with the value 12 and replace position 2 with the value 2. What value is left at position 0 after the program halts?
###

codes = File.read('2/input.txt').chomp.split(',').map(&:to_i)

# Pre-proccessing
codes[1] = 12
codes[2] = 2

position = 0
while codes[position] != 99
  if codes[position] == 1
    val1_pos = codes[position + 1]
    val2_pos = codes[position + 2]
    sum_pos = codes[position + 3]

    val1 = codes[val1_pos]
    val2 = codes[val2_pos]

    codes[sum_pos] = val1 + val2

    position += 4
  elsif codes[position] == 2
    val1_pos = codes[position + 1]
    val2_pos = codes[position + 2]
    product_pos = codes[position + 3]

    val1 = codes[val1_pos]
    val2 = codes[val2_pos]

    codes[product_pos] = val1 * val2
    position += 4
  else
    raise "Invalid opcode #{codes[position]} found at position #{position}."
  end
end

puts "The solution to part one is: #{codes[0]}"
