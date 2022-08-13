# frozen_string_literal: true

require 'test_helper'

class TestList < Minitest::Test
  def setup
    @empty = Rubisp::List.new
    @single_cell = Rubisp::List.new(Rubisp::Atom.new(1))
    @multiple_cells = Rubisp::List.new(*(0..10).map{ Rubisp::Atom.new(_1) })
  end

  def test_car
    assert_equal Rubisp::Nil, @empty.car
    assert_equal Rubisp::Atom.new(1), @single_cell.car
    assert_equal Rubisp::Atom.new(0), @multiple_cells.car
  end

  def test_cdr
    assert_equal Rubisp::Nil, @empty.cdr
    assert_equal Rubisp::Nil, @single_cell.cdr
    assert_equal Rubisp::List.new(*(1..10).map{ Rubisp::Atom.new(_1) }),
      @multiple_cells.cdr
  end

  def test_nil
    assert @empty.is_nil?
    assert_not @single_cell.is_nil?
    assert_not @multiple_cells.is_nil?
  end

  def test_eq
    assert_equal @empty, Rubisp::Nil
    assert_not_equal @empty, Rubisp::T
    assert_equal @single_cell, Rubisp::List.new(Rubisp::Atom.new(1))
    assert_not_equal @multiple_cells, @single_cell
  end
end

