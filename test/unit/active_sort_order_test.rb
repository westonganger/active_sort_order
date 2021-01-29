require "test_helper"

class ActiveSortOrderTest < ActiveSupport::TestCase

  def setup
  end

  def teardown
  end

  def test_exposes_main_module
    assert ActiveSortOrder.is_a?(Module)
  end

  def test_exposes_version
    assert ActiveSortOrder::VERSION
  end

  def test_class_base_order_only
    assert_equal Post.all.count, DATA[:posts].count

    sorted = PostWithBaseOrderA.all.sort_order

    expected = DATA[:posts].sort_by{|item| item.a }

    sorted.each_with_index do |item, i|
      assert_equal item.id, expected[i].id
    end

    sorted = PostWithBaseOrderB.all.sort_order

    expected = DATA[:posts].sort_by{|item| item.b }

    sorted.each_with_index do |item, i|
      assert_equal item.b, expected[i].b ### use b instead of id as its not unique
    end

    sorted = PostWithBaseOrderAAndB.all.sort_order

    expected = DATA[:posts].sort_by{|item| [item.a, item.b] }

    sorted.each_with_index do |item, i|
      assert_equal item.id, expected[i].id
    end

    sorted = PostWithBaseOrderBAndA.all.sort_order

    expected = DATA[:posts].sort_by{|item| [item.b, item.a] }

    sorted.each_with_index do |item, i|
      assert_equal item.id, expected[i].id
    end
  end

  def test_override_base_order_only
    assert_equal Post.all.count, DATA[:posts].count

    sorted = PostWithBaseOrderA.all.sort_order(base_sort_order: "posts.b ASC")

    expected = DATA[:posts].sort_by{|item| item.b }

    sorted.each_with_index do |item, i|
      assert_equal item.b, expected[i].b ### use b instead of id as its not unique
    end
  end

  def test_sort_only
    assert_equal Post.all.count, DATA[:posts].count

    expected = DATA[:posts].sort_by{|item| item.a }.reverse

    sorted = PostWithBaseOrderA.all.sort_order(:a, :desc)

    sorted.each_with_index do |item, i|
      assert_equal item.id, expected[i].id
    end

    sorted = PostWithBaseOrderA.all.sort_order("posts.a", "DESC")

    sorted.each_with_index do |item, i|
      assert_equal item.id, expected[i].id
    end
  end

  def test_base_order_and_sort
    assert_equal Post.all.count, DATA[:posts].count

    sorted = PostWithBaseOrderA.all.sort_order("posts.a", "DESC")

    expected = DATA[:posts].sort_by{|item| item.a }.reverse

    sorted.each_with_index do |item, i|
      assert_equal item.id, expected[i].id
    end

    sorted = PostWithBaseOrderB.all.sort_order("posts.b", "DESC")

    expected = DATA[:posts].sort_by{|item| item.b }.reverse

    sorted.each_with_index do |item, i|
      assert_equal item.b, expected[i].b ### use b instead of id as its not unique
    end
  end

end
