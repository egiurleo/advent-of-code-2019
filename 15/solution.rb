require_relative './intcode.rb'
require 'byebug'

memory = File.read('15/input.txt').chomp.split(',')

class Graph
  def inspect
    "<Graph>"
  end

  def initialize(map)
    @nodes = {}

    map.each do |coord, value|
      @nodes[coord] = Node.new(coord, value) if value != 0
    end

    @nodes.values.each do |node|
      x, y = node.position

      [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]].each do |coord|
        if neighbor = @nodes[coord]
          node.add_neighbor(neighbor)
        end
      end
    end
  end

  def distance_to_oxygen
    curr_node = @nodes[[0, 0]] || Node.new([0, 0], 1)
    curr_node.distance = 0

    queue = []

    while curr_node.value != 2
      curr_node.see
      neighbors = curr_node.neighbors.select { |n| !n.seen }
      neighbors.each { |n| n.distance = curr_node.distance + 1 }

      queue.concat(neighbors)

      curr_node = queue.shift
    end

    return curr_node.distance
  end

  def time_to_fill
    curr_node = @nodes.values.find { |n| n.value == 2 }
    curr_node.distance = 0

    queue = []

    while true
      curr_node.see
      neighbors = curr_node.neighbors.select { |n| !n.seen }
      neighbors.each { |n| n.distance = curr_node.distance + 1 }

      queue.concat(neighbors)

      break if queue.empty?

      curr_node = queue.shift
    end

    max_distance = -1 * Float::INFINITY
    @nodes.values.each do |node|
      max_distance = node.distance if node.distance > max_distance
    end

    return max_distance
  end
end

class Node
  attr_reader :position, :neighbors, :seen, :value, :distance

  def initialize(position, value)
    @position = position
    @value = value
    @neighbors = []
    @seen = false
  end

  def inspect
    "<Node @position=#{@position} @value=#{@value}>"
  end

  def distance=(distance)
    @distance = distance
  end

  def see
    @seen = true
  end

  def add_neighbor(node)
    @neighbors << node
  end
end

class Droid
  attr_reader :map

  def initialize(memory)
    @program = Intcode.new(memory)
    @found_oxygen = false
    @map = {}
    @visited = []
    @x = 0
    @y = 0
  end

  def position
    [@x, @y]
  end

  def build_map
    while !@found_oxygen
      neighbors = {
        move_east:  [@x + 1, @y],
        move_west:  [@x - 1, @y],
        move_south: [@x, @y + 1],
        move_north: [@x, @y - 1],
      }
      break_to_beginning = false

      neighbors.each do |method, coord|
        if @map[coord].nil?
          output = self.send(method)
          break_to_beginning = true if output != 0
          break if break_to_beginning
        end
      end

      next if break_to_beginning

      viable_neighbors = neighbors.select { |_, c| @map[c] != 0 }
      least_recently_visited = least_recently_visited(viable_neighbors.values)
      method = viable_neighbors.find { |_, c| c == least_recently_visited }.first
      self.send(method)
    end
  end

  def build_full_map
    no_new_space_found = 0

    while no_new_space_found < 200 do
      neighbors = {
        move_east:  [@x + 1, @y],
        move_west:  [@x - 1, @y],
        move_south: [@x, @y + 1],
        move_north: [@x, @y - 1],
      }
      break_to_beginning = false

      neighbors.each do |method, coord|
        if @map[coord].nil?
          output = self.send(method)
          break_to_beginning = true if output != 0
          no_new_space_found = 0 if break_to_beginning
          break if break_to_beginning
        end
      end

      next if break_to_beginning

      viable_neighbors = neighbors.select { |_, c| @map[c] != 0 }
      least_recently_visited = least_recently_visited(viable_neighbors.values)
      method = viable_neighbors.find { |_, c| c == least_recently_visited }.first
      no_new_space_found += 1
      self.send(method)
    end
  end

  def distance_to_oxygen
    graph = Graph.new(@map)
    graph.distance_to_oxygen
  end

  def time_to_fill
    graph = Graph.new(@map)
    graph.time_to_fill
  end

  private

  def least_recently_visited(coords)
    least_recent_idx = @visited.length
    least_recent_coord = nil

    coords.each do |coord|
      idx = @visited.index(coord) || -1
      if idx < least_recent_idx
        least_recent_idx = idx
        least_recent_coord = coord
      end
    end

    least_recent_coord
  end

  def visit(coord)
    if @visited.include?(coord)
      @visited.delete(coord)
    end

    @visited << coord
  end

  def handle_output(x, y, output)
    @map[[x, y]] = output

    if output != 0
      @x, @y = [x, y]
      visit([x, y])
    end

    @found_oxygen = true if output == 2

    output
  end

  # ----- MOVE -----
  def move_north
    @program.input([1])
    @program.run

    output = @program.output.first
    handle_output(@x, @y - 1, output)
  end

  def move_south
    @program.input([2])
    @program.run

    output = @program.output.first
    handle_output(@x, @y + 1, output)
  end

  def move_west
    @program.input([3])
    @program.run

    output = @program.output.first
    handle_output(@x - 1, @y, output)
  end

  def move_east
    @program.input([4])
    @program.run

    output = @program.output.first
    handle_output(@x + 1, @y, output)
  end
end

# droid = Droid.new(memory)
# droid.build_map

# puts "The solution to part one is: #{droid.distance_to_oxygen}"

droid = Droid.new(memory)
droid.build_full_map

puts "The solution to part two is: #{droid.time_to_fill}"
