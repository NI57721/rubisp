# frozen_string_literal: true

require 'test_helper'

class TestAtom < Minitest::Test
  def setup
    @integer  = Rubisp::Atom.new(1)
    @float    = Rubisp::Atom.new(1.0)
    @rational = Rubisp::Atom.new(1r)
    @complex  = Rubisp::Atom.new(1i)
    @nil      = Rubisp::Atom.new
    @t        = Rubisp::Atom.new(true)
    @symbol   = Rubisp::Atom.new('1')
  end

  def test_number
    [@integer, @float, @rational, @complex].each do |atom|
      assert atom.number?
      assert_not atom.is_nil?
      assert_not atom.t?
      assert_not atom.symbol?
    end
  end

  def test_nil
    assert @nil.is_nil?
    assert_not @nil.number?
    assert_not @nil.t?
    assert_not @nil.symbol?
  end

  def test_t
    assert @t.t?
    assert_not @t.number?
    assert_not @t.is_nil?
    assert_not @t.symbol?
  end

  def test_symbol
    assert @symbol.symbol?
    assert_not @symbol.number?
    assert_not @symbol.is_nil?
    assert_not @symbol.t?
  end

  def test_eq
    assert_equal @rational, @integer
    assert_not_equal @symbol, @integer
    assert_not_equal Rubisp::Nil, @nil
  end
end

