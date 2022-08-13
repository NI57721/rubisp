# frozen_string_literal: true

require 'test_helper'

class TestNilClass < Minitest::Test
  def setup
    @nil = Rubisp::Nil
  end

  def test_singleton
    assert @nil.equal?(Rubisp::NilClass.instance)
  end

  def test_to_string
    assert_equal 'nil', @nil.to_s
    assert_equal 'nil', @nil.inspect
  end
end

