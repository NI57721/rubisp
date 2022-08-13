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

  def test_eq
    assert_equal @nil, @nil
    assert_equal @nil, Rubisp::NilClass.instance
    assert_equal @nil, Rubisp::List.new
    assert_not_equal @nil, nil
    assert_not_equal @nil, false
    assert_not_equal @nil, Rubisp::T
  end
end

