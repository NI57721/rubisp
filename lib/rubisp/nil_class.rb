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

    def ==(other)
      return other.is_nil? if other.is_a?(Rubisp::List)
      other.equal?(NilClass.instance)
    end

    alias eql? ==
  end

  Nil = NilClass.instance
end

