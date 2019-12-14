require 'rubyvis'
require 'byebug'
require_relative './moon.rb'

# First half of the number
positions = [[13, 9, 5], [8, 14, -2], [-5, 4, 11], [2, -6, 1]]
system = SolarSystem.new(positions)

x1 = []
x2 = []
x3 = []
x4 = []

y1 = []
y2 = []
y3 = []
y4 = []

(0..100).to_a.each do |x|
  moons = system.moons
  system.time_step

  x1 << OpenStruct.new({ :x => x, :y => moons[0].position.first })
  x2 << OpenStruct.new({ :x => x, :y => moons[1].position.first })
  x3 << OpenStruct.new({ :x => x, :y => moons[2].position.first })
  x4 << OpenStruct.new({ :x => x, :y => moons[3].position.first })

  y1 << OpenStruct.new({ :x => x, :y => moons[0].position[1] })
  y2 << OpenStruct.new({ :x => x, :y => moons[1].position[1] })
  y3 << OpenStruct.new({ :x => x, :y => moons[2].position[1] })
  y4 << OpenStruct.new({ :x => x, :y => moons[3].position[1] })
end

w = 1000
h = 500

x_scale_1 = pv.Scale.linear(x3, lambda {|d| d.x}).range(0, w)
y_scale_1 = pv.Scale.linear(x3, lambda {|d| d.y}).range(0, h);

vis1 = pv.Panel.new()
  .width(w)
  .height(h)
  .bottom(20)
  .left(20)
  .right(10)
  .top(5)

vis2 = pv.Panel.new()
  .width(w)
  .height(h)
  .bottom(20)
  .left(20)
  .right(10)
  .top(5)

[[x1, 'red'], [x2, 'blue'], [x3, 'green'], [x4, 'yellow']].each do |data, color|
  vis1.add(pv.Line).
    data(data).
    line_width(2).
    left(lambda {|d| x_scale_1.scale(d.x)}).
    bottom(lambda {|d| y_scale_1.scale(d.y)}).
    anchor("bottom").add(pv.Line).
      stroke_style(color).
      line_width(2)
end

[[y1, 'red'], [y2, 'blue'], [y3, 'green'], [y4, 'yellow']].each do |data, color|
  vis2.add(pv.Line).
    data(data).
    line_width(2).
    left(lambda {|d| x_scale_1.scale(d.x)}).
    bottom(lambda {|d| y_scale_1.scale(d.y)}).
    anchor("bottom").add(pv.Line).
      stroke_style(color).
      line_width(2)
end

vis1.render();
vis2.render();

open('12/graph.html', 'w') { |f|
  f.puts vis1.to_svg
  f.puts vis2.to_svg
}
