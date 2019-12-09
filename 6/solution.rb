require 'byebug'

$nodes = {}

class Node
  attr_reader :name
  attr_reader :orbit
  attr_reader :orbiters
  attr_reader :seen

  def initialize(name)
    @name = name
    @orbit = nil
    @orbiters = []
    @seen = false
  end

  def see
    @seen = true
  end

  def orbits(node)
    @orbit = node
  end

  def is_orbited_by(node)
    @orbiters << node
  end

  def score
    @score ||= @orbit.nil? ? 0 : @orbit.score + 1
  end
end

def get_or_create(name)
  unless $nodes[name]
    $nodes[name] = Node.new(name)
  end

  $nodes[name]
end

File.open('6/input.txt').each do |line|
  node1_name, node2_name = line.chomp.split(')')

  node1 = get_or_create(node1_name)
  node2 = get_or_create(node2_name)

  node1.is_orbited_by(node2)
  node2.orbits(node1)
end

orbits = $nodes.map { |_, node| node.score }.reduce(&:+)
puts "The solution to part one is: #{orbits}"

goal_node = $nodes['SAN'].orbit
current_node = $nodes['YOU'].orbit

def fewest_orbital_transfers(start_node, goal_node)
  current_node_info = { node: start_node, level: 0 }
  queue = []

  while current_node_info[:node] != goal_node
    current_node = current_node_info[:node]
    current_node.see

    next_nodes = [current_node.orbit].concat(current_node.orbiters).compact.filter{ |node| !node.seen }
    next_nodes_info = next_nodes.map { |node| { node: node, level: current_node_info[:level] + 1 } }

    queue.concat(next_nodes_info)

    return Float::INFINITY if queue.empty?

    current_node_info = queue.shift
  end

  return current_node_info[:level]
end

puts "The solution to part two is: #{fewest_orbital_transfers(current_node, goal_node)}"