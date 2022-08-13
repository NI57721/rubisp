# frozen_string_literal: true

require 'test_helper'

class TestRubisp < Minitest::Test
  def setup
    @t = Rubisp::T
  end

  def test_singleton
    assert @t.equal?(Rubisp::TrueClass.instance)
  end

  def test_to_string
    assert_equal 't', @t.to_s
    assert_equal 't', @t.inspect
  end
end

