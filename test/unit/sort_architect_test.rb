require "test_helper"

class SortArchitectTest < ActiveSupport::TestCase

  def test_exposes_main_module
    assert SortArchitect.is_a?(Module)
  end

  def test_exposes_version
    assert SortArchitect::VERSION
  end

end
