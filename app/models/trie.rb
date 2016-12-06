class Node
  attr_accessor :children, :terminal
  attr_reader :id

  def initialize(id)
    @id = id
    @children = []
    @terminal = false
  end

end


