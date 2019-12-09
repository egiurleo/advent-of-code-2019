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

goal_node = $nodes['SAN']
current_node = $nodes['YOU'].orbit
def fewest_orbital_transfers(current_node, goal_node)
  current_node.see

  if current_node.orbiters.include?(goal_node)
    return 0
  end

  stack = [current_node.orbit].concat(current_node.orbiters).compact.filter{ |node| !node.seen }

  if stack.empty?
    return Float::INFINITY
  end

  result = stack.map { |node| fewest_orbital_transfers(node, goal_node) + 1 }.min

  return result
end

puts "The solution to part two is: #{fewest_orbital_transfers(current_node, goal_node)}"