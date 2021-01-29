class PostWithBaseOrderBAndA < Post

  def self.base_sort_order
    "posts.b ASC, posts.a ASC"
  end

end
