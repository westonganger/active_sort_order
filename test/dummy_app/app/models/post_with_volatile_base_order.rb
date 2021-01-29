class PostWithVolatileBaseOrder < Post

  def self.base_sort_order
    # Will be overwritten in tests
  end

end
