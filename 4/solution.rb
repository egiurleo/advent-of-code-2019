
input = '206938-679128'
low, high = input.split('-').map(&:to_i)

def adjacent_digits?(num)
  num_str = num.to_s
  num_arr = num_str.split('')

  for i in (0..num_arr.length - 2) do
    return true if num_arr[i] == num_arr[i + 1]
  end

  false
end

def two_adjacent_digits?(num)
  num_str = num.to_s
  num_arr = num_str.split('')

  num_matching = 0
  num_to_match = nil
  for i in (0..num_arr.length) do
    if num_arr[i] == num_arr[i - 1]
      num_matching += 1
    else
      return true if num_matching == 2

      num_matching = 1
      num_to_match = num_arr[i]
    end

    next
  end

  false
end

def ascending_digits?(num)
  num_str = num.to_s
  num_arr = num_str.split('').map(&:to_i)

  for i in (0..num_arr.length - 2) do
    return false if num_arr[i] > num_arr[i + 1]
  end

  true
end

###
# PART ONE
# You arrive at the Venus fuel depot only to discover it's protected by a password. The Elves had written the password on a sticky note, but someone threw it out.
# However, they do remember a few key facts about the password:
#   It is a six-digit number.
#   The value is within the range given in your puzzle input.
#   Two adjacent digits are the same (like 22 in 122345).
#   Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
# How many different passwords within the range given in your puzzle input meet these criteria?
###

part_one_result = (low..high)
  .to_a
  .select do |num|
    adjacent_digits?(num) && ascending_digits?(num)
  end.length

puts "The solution to part one is: #{part_one_result}"

###
# PART TWO:
# An Elf just remembered one more important detail: the two adjacent matching digits are not part of a larger group of matching digits.
# How many different passwords within the range given in your puzzle input meet all of the criteria?
###

part_two_result = (low..high)
  .to_a
  .select do |num|
    two_adjacent_digits?(num) && ascending_digits?(num)
  end.length

puts "The solution to part two is: #{part_two_result}"
