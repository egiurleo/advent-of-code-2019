###
# To complete the gravity assist, you need to determine what pair of inputs produces the output 19690720."
# The inputs should still be provided to the program by replacing the values at addresses 1 and 2, just like before. In this program, the value placed in address 1 is called the noun, and the value placed in address 2 is called the verb. Each of the two input values will be between 0 and 99, inclusive.
#
# Once the program has halted, its output is available at address 0, also just like before. Each time you try a pair of inputs, make sure you first reset the computer's memory to the values in the program (your puzzle input) - in other words, don't reuse memory from a previous attempt.
#
# Find the input noun and verb that cause the program to produce the output 19690720.
###

require 'rubyvis'
require_relative './shared.rb'

# First half of the number
data1 = (0..99).to_a.map do |x|
  solution = run_intcode(x, 0)
  first_half = solution.to_s[0..3].to_i
  OpenStruct.new({ :x => x, :y => first_half })
end

# Second half of the number
data2 = (0..99).to_a.map do |x|
  solution = run_intcode(0, x)
  second_half = solution.to_s[4..7].to_i
  OpenStruct.new({ :x => x, :y => second_half })
end

#p data
w = 400
h = 200

x1 = pv.Scale.linear(data1, lambda {|d| d.x}).range(0, w)
y1 = pv.Scale.linear(data1, lambda {|d| d.y}).range(0, h);

x2 = pv.Scale.linear(data2, lambda {|d| d.x}).range(0, w)
y2 = pv.Scale.linear(data2, lambda {|d| d.y}).range(0, h);

#/* The root panel. */
vis1 = pv.Panel.new()
  .width(w)
  .height(h)
  .bottom(20)
  .left(20)
  .right(10)
  .top(5)

vis1.add(pv.Line).
  data(data1).
  line_width(5).
  left(lambda {|d| x1.scale(d.x)}).
  bottom(lambda {|d| y1.scale(d.y)}).
  anchor("bottom").add(pv.Line).
    stroke_style('red').
    line_width(1)

vis1.add(pv.Label)
  .left(75)
  .top(16)
  .textAlign("center")
  .text("noun value vs. first half of result");

vis2 = pv.Panel.new()
  .width(w)
  .height(h)
  .bottom(20)
  .left(20)
  .right(10)
  .top(5)

vis2.add(pv.Line).
  data(data2).
  line_width(5).
  left(lambda {|d| x2.scale(d.x)}).
  bottom(lambda {|d| y2.scale(d.y)}).
  anchor("bottom").add(pv.Line).
    stroke_style('black').
    line_width(1)

vis2.add(pv.Label)
  .left(75)
  .top(16)
  .textAlign("center")
  .text("verb value vs. second half of result");

vis1.render();
vis2.render;

open('2/graph.html', 'w') { |f|
  f.puts vis1.to_svg
  f.puts vis2.to_svg
}
