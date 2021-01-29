require "test_helper"

class ActiveSortOrderTest < ActiveSupport::TestCase

  def setup
  end

  def teardown
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

    invalid.each do |v|
      assert_raise ArgumentError do
        Post.sort_order(v, :asc).limit(1)
      end
    end

    assert_raise ArgumentError do
      Post.sort_order(Object.new, :asc).limit(1)
    end

    ### TEST UNIQUE CASES

    ### HASH - this is allowed because its treated as keyword arguments
    Post.sort_order({}).limit(1)

    assert_raise do
      Post.sort_order({}, :desc).limit(1)
    end
  end

  def test_sort_direction_errors
    valid_directions = [
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

    valid_directions.each do |direction|
      PostWithBaseOrderA.sort_order("x", direction).limit(1)

      if direction
        direction = direction.try!(:downcase)

        PostWithBaseOrderA.sort_order("x", direction).limit(1)

        direction = direction.try!(:to_sym)

        PostWithBaseOrderA.sort_order("foobar", direction).limit(1)
      end
    end

    bad_directions = [
      false,
      true,
      Object.new,
      [],
      'ASCC',
    ].freeze

    bad_directions.each do |direction|
      assert_raise ArgumentError do
        PostWithBaseOrderA.sort_order("foobar", direction).limit(1)
      end
    end

    ### TEST UNIQUE CASES

    ### HASH - this is allowed because its treated as keyword arguments
    Post.sort_order("foobar", {}).limit(1).to_sql.include?("foobar ASC")

    assert_raise do
      Post.sort_order("foobar", {}, {}).limit(1)
    end
  end

  def test_base_sort_order_errors
    valid = [
      nil,
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

    ### INVALID BASE_SORT_ORDER CLASS
    valid = [
      nil,
      false,
      "",
      "foobar",
    ]

    valid.each do |v|
      silence_warnings do
        PostWithVolatileBaseOrder.define_method :base_sort_order do
          v
        end
      end

      PostWithVolatileBaseOrder.sort_order(base_sort_order: v).limit(1)
    end

    invalid = [
      :foobar,
      [],
      {},
      Object.new,
    ]

    invalid.each do |v|
      silence_warnings do
        PostWithVolatileBaseOrder.define_method :base_sort_order do
          v
        end
      end

      assert_raise ArgumentError do
        PostWithVolatileBaseOrder.sort_order(base_sort_order: v).limit(1)
      end
    end
  end

end
