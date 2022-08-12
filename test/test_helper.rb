# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'rubisp'

require 'minitest/autorun'

class Minitest::Test
  alias assert_not refute
  alias assert_not_equal refute_equal
end

