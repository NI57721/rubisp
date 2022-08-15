# frozen_string_literal: true

module Rubisp
  class Lexer
    class Elem
      def initialize(pos, type, content = nil)
        @pos = pos
        @type = type
        @content = content
      end

      def to_s
        format('#<Rubisp::Lexer::Elem: %s@%p: %s', @type, @pos, @content)
      end
    end
  end
end

