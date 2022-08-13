# frozen_string_literal: true

require 'singleton'

module Rubisp
  class NilClass
    include Singleton

    def to_s
      'nil'
    end

    def inspect
      'nil'
    end
  end

  Nil = NilClass.instance
end

