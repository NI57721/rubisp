# frozen_string_literal: true

require 'test_helper'

class TestLexer < Minitest::Test
  def setup
    @code = "(quote (cond (t) (write \"foo\nbar\n\") (princ nil -.1 123)))"
    @invalid_code = "'('(1 . 2) 	\n  \"foo bar)"
  end

  def parse(code)
    instance_variable_names = %i[@pos @type @content]
    Rubisp::Lexer.parse(code).map do |elem|
      instance_variable_names.map { elem.instance_variable_get(_1) }
    end
  end

  def test_paren_and_space
    code = " (   	\n)  \n"
    assert_equal [
      [[1, 2], :lparen, nil],
      [[2, 1], :rparen, nil]
    ],
      parse(code)
  end

  def test_single_quote
    code = "'(  )"
    assert_equal [
      [[1, 1], :quote, nil],
      [[1, 2], :lparen, nil],
      [[1, 5], :rparen, nil]
    ],
      parse(code)
  end

  def test_valid_string
    code = '\'("foo bar")'
    assert_equal [
      [[1, 1], :quote, nil],
      [[1, 2], :lparen, nil],
      [[1, 3], :string_beg, nil],
      [[1, 4], :string, 'foo bar'],
      [[1, 11], :string_end, nil],
      [[1, 12], :rparen, nil]
    ],
      parse(code)
  end

  def test_invalid_string
    code = '\'("foo'
    assert_equal [
      [[1, 1], :quote, nil],
      [[1, 2], :lparen, nil],
      [[1, 3], :string_beg, nil],
      [[1, 4], :string, 'foo']
    ],
      parse(code)
  end

  def test_dot_pairand_integer
    code = '(0 . -12)'
    assert_equal [
      [[1, 1], :lparen, nil],
      [[1, 2], :integer, 0],
      [[1, 4], :dot, nil],
      [[1, 6], :integer, -12],
      [[1, 9], :rparen, nil]
    ],
      parse(code)
  end

  def test_float
    code = "'(-.1 +1. 3.14)"
    assert_equal [
      [[1, 1], :quote, nil],
      [[1, 2], :lparen, nil],
      [[1, 3], :float, -0.1],
      [[1, 7], :float, 1.0],
      [[1, 11], :float, 3.14],
      [[1, 15], :rparen, nil]
    ],
      parse(code)
  end

  def test_nil_and_t
    code = "'(nil t)"
    assert_equal [
      [[1, 1], :quote, nil],
      [[1, 2], :lparen, nil],
      [[1, 3], :nil, nil],
      [[1, 7], :t, nil],
      [[1, 8], :rparen, nil]
    ],
      parse(code)
  end

  def test_keyword
    code = "'(= 1 0)"
    assert_equal [
      [[1, 1], :quote, nil],
      [[1, 2], :lparen, nil],
      [[1, 3], :math_op, '='],
      [[1, 5], :integer, 1],
      [[1, 7], :integer, 0],
      [[1, 8], :rparen, nil]
    ],
      parse(code)
  end
end

