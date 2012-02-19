Collection = Struct.new(:name, :elements) do
  def representation
    { name => elements.map(&:representation) }
  end

  def as_json(options = nil)
    representation.as_json(options)
  end
end
