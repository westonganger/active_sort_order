require "test_helper"

class ActiveSortOrderTest < ActiveSupport::TestCase

  setup do
  end

  teardown do
  end
  
  def test_sort_str_errors
    ### TEST VALID
    valid = [
      "foo",
      :foo,
      nil,
      "",
    ]

    valid.each do |v|
      Post.sort_order(v, :asc).limit(1)
    end

    ### TEST INVALID
    invalid = [
      true,
      false,
      [],
      Object.new,
    ]

    if RUBY_VERSION.to_f >= 3.0
      invalid << {}
    end

    invalid.each do |v|
      assert_raise ArgumentError do
        Post.sort_order(v, :asc).limit(1)
      end
    end

    assert_raise ArgumentError do
      Post.sort_order(Object.new, :asc).limit(1)
    end

    ### TEST UNIQUE CASES

    if RUBY_VERSION.to_f < 3.0
      ### HASH - this is allowed because its treated as keyword arguments
      Post.sort_order({}).limit(1)

      assert_raise do
        Post.sort_order({}, :desc).limit(1)
      end
    end
  end

  def test_sort_direction_errors
    valid = [
      "ASC",
      "DESC",
      "ASC NULLS FIRST",
      "ASC NULLS LAST",
      "DESC NULLS FIRST",
      "DESC NULLS LAST",
      nil,
      "",

      ### NASTY BUT TECHNICALLY ALLOWED BECAUSE OF SANITIZATION TECHNIQUE
      "ASC   NULLS   FIRST",
      "   ASC   ",
      "ASC\n",
      "ASC\tNULLS\tFirst",
    ].freeze

    valid.each do |direction|
      PostWithBaseOrderA.sort_order("x", direction).limit(1)

      if direction
        direction = direction.try!(:downcase)

        PostWithBaseOrderA.sort_order("x", direction).limit(1)

        direction = direction.try!(:to_sym)

        PostWithBaseOrderA.sort_order("foobar", direction).limit(1)
      end
    end

    invalid = [
      false,
      true,
      Object.new,
      [],
      'ASCC',
    ]

    if RUBY_VERSION.to_f >= 3.0
      invalid << {}
    end

    invalid.each do |direction|
      assert_raise ArgumentError do
        PostWithBaseOrderA.sort_order("foobar", direction).limit(1)
      end
    end

    ### TEST UNIQUE CASES

    if RUBY_VERSION.to_f < 3.0
      ### HASH - this is allowed because its treated as keyword arguments
      Post.sort_order("foobar", {}).limit(1).to_sql.include?("foobar ASC")

      assert_raise do
        Post.sort_order("foobar", {}, {}).limit(1)
      end
    end
  end

  def test_argument_base_sort_order_errors
    assert_not Post.respond_to?(:base_sort_order)

    valid = [
      nil,
      true,
      false,
      "",
      "foobar",
    ]

    valid.each do |v|
      Post.sort_order(base_sort_order: v).limit(1)
    end

    invalid = [
      :foobar,
      [],
      {},
      Object.new,
    ]

    invalid.each do |v|
      assert_raise ArgumentError do
        Post.sort_order(base_sort_order: v).limit(1)
      end
    end
  end

  def test_class_method_base_sort_order_errors
    klass = PostWithVolatileBaseOrder

    assert klass.respond_to?(:base_sort_order)

    valid = [
      nil,
      false,
      "",
      "foobar",
    ]

    valid.each do |v|
      silence_warnings do
        klass.define_singleton_method :base_sort_order do
          v
        end
      end

      if v.nil?
        assert_nil klass.base_sort_order
      else
        assert_equal v, klass.base_sort_order
      end

      klass.sort_order.limit(1)
    end

    invalid = [
      true,
      :foobar,
      [],
      {},
      Object.new,
    ]

    invalid.each do |v|
      silence_warnings do
        klass.define_singleton_method :base_sort_order do
          v
        end
      end

      if v.nil?
        assert_nil klass.base_sort_order
      else
        assert_equal v, klass.base_sort_order
      end

      assert_raise ArgumentError do
        klass.sort_order.limit(1)
      end
    end
  end

end
