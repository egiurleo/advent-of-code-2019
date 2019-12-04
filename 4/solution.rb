
input = '206938-679128'
low, high = input.split('-').map(&:to_i)

def adjacent_digits?(num)
  num_str = num.to_s
  digits = num_str.split('')

  digits.each_cons(2).any? do |dig1, dig2|
    dig1 == dig2
  end
end

def two_adjacent_digits?(num)
  num_str = num.to_s
  digits = num_str.split('')

  num_matching = 1
  num_to_match = digits.first

  digits.each_cons(2).each do |dig1, dig2|
    if dig1 == dig2
      num_matching += 1
    else
      return true if num_matching == 2

      num_matching = 1
      num_to_match = dig1
    end
  end

  num_matching == 2
end

def ascending_digits?(num)
  num_str = num.to_s
  digits = num_str.split('').map(&:to_i)

  digits.each_cons(2).all? do |dig1, dig2|
    dig1 <= dig2
  end
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