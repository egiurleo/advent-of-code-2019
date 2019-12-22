require 'byebug'

class Element
  attr_reader :name, :value

  def initialize(name, value)
    @name = name
    @value = value
  end
end

class Reaction
  attr_reader :inputs, :output

  def initialize(text)
    input, output = text.split('=>').map(&:chomp)
    @inputs = input.split(',').map { |i| process_text(i) }
    @output = process_text(output)
  end

  # scale is the number of output elements you want
  def scaled_inputs(scale)
    multiplier = (scale.to_f/@output.value.to_f).ceil

    @inputs.map do |input|
      Element.new(input.name, input.value * multiplier)
    end
  end

  private

  def process_text(text)
    value, name = text.chomp.split(' ')
    Element.new(name, value.to_i)
  end
end

class System
  attr_reader :reactions

  def initialize
    @reactions = {}

    File.open('14/input.txt').each do |line|
      reaction = Reaction.new(line.chomp)
      @reactions[reaction.output.name] = reaction
    end
  end

  def num_ore_to_fuel(scale)
    elements = @reactions['FUEL'].scaled_inputs(scale)
    levels = element_levels

    while level = levels.pop do
      elements = elements.map do |element|
        if level.include?(element.name) && element.name != 'ORE'
          reaction = @reactions[element.name]
          reaction.scaled_inputs(element.value)
        else
          element
        end
      end.flatten

      elements = combine_elements(elements)
    end

    elements.map(&:value).reduce(&:+)
  end

  private

  def element_levels
    levels = [['ORE']]

    while levels.flatten.length < @reactions.length + 1
      used_elements = levels.flatten

      level = @reactions.values.select do |reaction|
        reaction.inputs.all? { |element| used_elements.include?(element.name) } && !used_elements.include?(reaction.output.name)
      end.map do |reaction|
        reaction.output.name
      end

      levels << level
    end

    levels
  end

  def combine_elements(elements)
    elements.reduce({}) do |obj, el|
      obj[el.name] = 0 unless obj[el.name]
      obj[el.name] += el.value
      obj
    end.map do |name, value|
      Element.new(name, value)
    end
  end
end

system = System.new
puts "The solution to part one is: #{system.num_ore_to_fuel(1)}"

input = ''
while input != 'exit'
  print "How much fuel? "
  input = gets.chomp
  ore = system.num_ore_to_fuel(input.to_i)

  if ore > 1000000000000
    puts "You need #{ore} ORE. That's too much."
  elsif ore < 1000000000000
    puts "You need #{ore} ORE. That's too little."
  else
    puts "That's the right amount of ore!"
  end
end
