# frozen_string_literal: true

require 'singleton'

module Rubisp
  class TrueClass
    include Singleton

    def to_s
      't'
    end

    def inspect
      't'
    end
  end

  T = TrueClass.instance
end

