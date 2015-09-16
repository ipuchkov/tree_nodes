@index = 1

def add_node(value, parent = nil)
  Node.create(:value => value).tap do |node|
    if parent
      node.parent = parent
      node.save
    end
  end
end

def add_children(n, parent)
  nodes = []
  n.times do
    @index += 1
    nodes << add_node("node#{@index}", parent = parent)
  end

  nodes
end

root = add_node('node1')
level1 = add_children(5, root)
level2 = level1.flat_map {|node| add_children(4, node)}
level3 = level2.flat_map {|node| add_children(3, node)}
level4 = level3.flat_map {|node| add_children(2, node)}
