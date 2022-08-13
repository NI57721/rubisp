# frozen_string_literal: true

module Rubisp
  class Atom
    attr_reader :value, :type

    def initialize(value = nil)
      case value
      when Numeric
        @type = :number
        @value = value
      when nil
        @type = :nil
        @value = Rubisp::Nil
      when true
        @type = :t
        @value = Rubisp::T
      else
        @type = :symbol
        @value = value.to_s
      end
    end

    def to_s
      @value.to_s
    end

    def inspect
      @value.inspect
    end

    def ==(other)
      other.is_a?(Atom) ? (@type == other.type && @value == other.value) : false
    end

    alias eql? ==

    def number?
      @type == :number
    end

    # Avoid override Object#.nil?
    def is_nil? # rubocop:disable Naming/PredicateName
      @type == :nil
    end

    def t?
      @type == :t
    end

    def symbol?
      @type == :symbol
    end
  end
end

