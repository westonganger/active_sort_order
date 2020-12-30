require "test_helper"

class ActiveRecordSearchAndSortTest < Minitest::Test

  def test_exposes_main_module
    assert ActiveRecordSearchAndSort.is_a?(Module)
  end

  def test_exposes_version
    assert ActiveRecordSearchAndSort::VERSION
  end

  def test_sort_lifecycle
  end

  def test_search_lifecycle
  end

end
