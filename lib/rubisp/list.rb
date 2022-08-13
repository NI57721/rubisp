# frozen_string_literal: true

module Rubisp
  class List
    attr_reader :size, :cells

    def initialize(*args)
      @size = args.size
      @cells = args
    end

    def to_s
      format('(%s)', @cells.map(&:to_s).join(' '))
    end

    def inspect
      format('#<List:%016x %s>', object_id, to_s)
    end

    def length
      @size
    end

    def car
      @size.zero? ? Rubisp::Nil : @cells[0]
    end

    def cdr
      @size < 2 ? Rubisp::Nil : List.new(*@cells[1..])
    end

    def ==(other)
      return other == Rubisp::Nil && @size.zero? unless other.is_a?(List)
      @cells == other.cells
    end

    alias eql? ==

    # Avoid override Object#.nil?
    # rubocop:disable Naming/PredicateName
    def is_nil?
      @cells.empty?
    end
    # rubocop:enable Naming/PredicateName
  end
end

