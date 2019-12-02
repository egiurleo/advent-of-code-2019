masses = File.open('1/input.txt').map do |line|
  line.chomp.to_f
end

# PART ONE
#
# At the first Go / No Go poll, every Elf is Go until the Fuel Counter-Upper. They haven't determined the amount of fuel required yet.
#
# Fuel required to launch a given module is based on its mass. Specifically, to find the fuel required for a module, take its mass, divide by three, round down, and subtract 2.
#
# The Fuel Counter-Upper needs to know the total fuel requirement. To find it, individually calculate the fuel needed for the mass of each module (your puzzle input), then add together all the fuel values.
#
# What is the sum of the fuel requirements for all of the modules on your spacecraft?

def required_fuel(mass)
  fuel = (mass / 3).floor - 2
  fuel < 0 ? 0 : fuel
end

fuel_one = masses.map do |mass|
  required_fuel(mass)
end.reduce(&:+)

puts "The solution to Part One is: #{fuel_one}."

# PART TWO
#
# During the second Go / No Go poll, the Elf in charge of the Rocket Equation Double-Checker stops the launch sequence. Apparently, you forgot to include additional fuel for the fuel you just added.
#
# Fuel itself requires fuel just like a module - take its mass, divide by three, round down, and subtract 2. However, that fuel also requires fuel, and that fuel requires fuel, and so on. Any mass that would require negative fuel should instead be treated as if it requires zero fuel; the remaining mass, if any, is instead handled by wishing really hard, which has no mass and is outside the scope of this calculation.
#
# What is the sum of the fuel requirements for all of the modules on your spacecraft when also taking into account the mass of the added fuel? (Calculate the fuel requirements for each module separately, then add them all up at the end.)

def required_fuel_rec(mass)
  return 0 if mass <= 0

  fuel = (mass / 3).floor - 2
  fuel + required_fuel_rec(fuel)
end

fuel_two = masses.map do |mass|
  required_fuel_rec(mass)
end.reduce(&:+)

puts "The solution to Part Two is: #{fuel_two}."
