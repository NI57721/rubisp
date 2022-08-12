# frozen_string_literal: true

require 'test_helper'

class TestRubisp < Minitest::Test
  def setup
    @cons = Rubisp::Cons.new(1, 2)
    @other = Rubisp::Cons.new(3, 4)
  end

  def test_cons_constructor
    assert_equal 1, @cons.car
    assert_equal 2, @cons.cdr
    @cons.car = 3
    @cons.cdr = 4
    assert_equal 3, @cons.car
    assert_equal 4, @cons.cdr
  end

  def test_compare_cons
    assert_not_equal @other, @cons
    @other.car = @cons.car
    @other.cdr = @cons.cdr
    assert_equal @other, @cons
  end
end

