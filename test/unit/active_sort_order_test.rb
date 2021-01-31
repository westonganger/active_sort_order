require "test_helper"

class ActiveSortOrderTest < ActiveSupport::TestCase

  setup do
  end

  teardown do
  end

  def test_exposes_main_module
    assert ActiveSortOrder.is_a?(Module)
  end

  def test_exposes_version
    assert ActiveSortOrder::VERSION
  end

  def test_base_sort_order_default_value
    klass = PostWithBaseOrderA

    assert PostWithBaseOrderA.unscoped.sort_order.to_sql.include?("ORDER BY #{klass.base_sort_order}")

    assert PostWithBaseOrderA.unscoped.sort_order(base_sort_order: true).to_sql.include?("ORDER BY #{klass.base_sort_order}")
  end

  def test_class_base_sort_order_only
    assert_equal Post.all.count, DATA[:posts].count

    sorted = PostWithBaseOrderA.all.sort_order

    expected = DATA[:posts].sort_by{|item| item.a }

    sorted.each_with_index do |item, i|
      assert_equal expected[i].id, item.id
    end

    sorted = PostWithBaseOrderB.all.sort_order

    expected = DATA[:posts].sort_by{|item| item.b }

    sorted.each_with_index do |item, i|
      assert_equal expected[i].b, item.b ### use b instead of id as its not unique
    end

    sorted = PostWithBaseOrderAAndB.all.sort_order

    expected = DATA[:posts].sort_by{|item| [item.a, item.b] }

    sorted.each_with_index do |item, i|
      assert_equal expected[i].id, item.id
    end

    sorted = PostWithBaseOrderBAndA.all.sort_order

    expected = DATA[:posts].sort_by{|item| [item.b, item.a] }

    sorted.each_with_index do |item, i|
      assert_equal expected[i].id, item.id
    end
  end

  def test_override_base_sort_order_only
    assert_equal Post.all.count, DATA[:posts].count

    sorted = PostWithBaseOrderA.order(b: :desc).sort_order(base_sort_order: "posts.b ASC")

    expected = DATA[:posts].sort_by{|item| item.b }

    sorted.each_with_index do |item, i|
      assert_equal expected[i].b, item.b ### use b instead of id as its not unique
    end

    expected = DATA[:posts].sort_by{|item| item.id }

    ### NIL & FALSE
    [nil, false].each do |v|
      sorted = PostWithBaseOrderA.order(a: :desc).sort_order(base_sort_order: v)

      sorted.each_with_index do |item, i|
        assert_equal expected[i].id, item.id
      end
    end
  end

  def test_sort_only
    assert_equal Post.all.count, DATA[:posts].count

    expected = DATA[:posts].sort_by{|item| item.a }.reverse

    sorted = PostWithBaseOrderA.all.sort_order(:a, :desc)

    sorted.each_with_index do |item, i|
      assert_equal expected[i].id, item.id
    end

    sorted = PostWithBaseOrderA.all.sort_order("posts.a", "DESC")

    sorted.each_with_index do |item, i|
      assert_equal expected[i].id, item.id
    end
  end

  def test_base_sort_order_and_sort
    assert_equal Post.all.count, DATA[:posts].count

    sorted = PostWithBaseOrderA.all.sort_order("posts.a", "DESC")

    expected = DATA[:posts].sort_by{|item| item.a }.reverse

    sorted.each_with_index do |item, i|
      assert_equal expected[i].id, item.id
    end

    sorted = PostWithBaseOrderB.all.sort_order("posts.b", "DESC")

    expected = DATA[:posts].sort_by{|item| item.b }.reverse

    sorted.each_with_index do |item, i|
      assert_equal expected[i].b, item.b ### use b instead of id as its not unique
    end
  end

end
