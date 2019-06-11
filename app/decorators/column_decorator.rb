module ColumnDecorator
  def arrow_link_class(direction)
    if (first? && direction == :left) || (last? && direction == :right)
      'text-middle-purple hover-middle-purple invisible'
    else
      'text-middle-purple hover-middle-purple'
    end
  end
end
