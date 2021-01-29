class PostWithBaseOrderAAndB < Post

  def self.base_sort_order
    "posts.a ASC, posts.b ASC"
  end

end
