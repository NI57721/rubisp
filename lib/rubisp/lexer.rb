# frozen_string_literal: true

module Rubisp
  class Lexer # rubocop:disable Metrics/ClassLength
    def self.parse(src, filename = '(ripper)')
      new(src, filename).parse
    end

    def initialize(src, filename = '(ripper)')
      @src = src.is_a?(String) ? src : src.read
      @filename = filename
      @pos = 0
    end

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
    # rubocop:disable Layout/IndentationWidth
    def parse
      elems = []
      loop do
        break(elems) if @pos >= @src.size
        case @src[@pos..]
        when /\A\s+/m              then parse_space(Regexp.last_match)
        when /\A'/                 then parse_single_quote(elems)
        when /\A"/                 then parse_double_quote(elems)
        when /\A\(/                then parse_lparen(elems)
        when /\A\)/                then parse_rparen(elems)
        when /\A\.(?=\s)/          then parse_dot(elems)
        when /\A[-+]?(?:0?|[1-9]\d*)\.\d*/
                                        parse_float(elems, Regexp.last_match)
        when /\A[-+]?(0|[1-9]\d*)/ then parse_integer(elems, Regexp.last_match)
        when /\Anil\b/             then parse_nil(elems, Regexp.last_match)
        when /\At\b/               then parse_t(elems, Regexp.last_match)
        when /\A[a-zA-Z_=][-=\w]*/ then parse_keyword(elems, Regexp.last_match)
        else                            raise_failure_to_parse
        end
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity
    # rubocop:enable Layout/IndentationWidth

    private

    def raise_failure_to_parse
      r, c = code_pos
      line = "#{@src.chomp}\n".lines[r - 1]
      msg = format(
        "failed to parse:@[%d, %d]\n%s%s^", r, c, line, ' ' * (c - 1)
      )
      raise(msg)
    end

    def code_pos
      lf_count = @src[0..@pos].count("\n")
      [lf_count + 1, @src[0..@pos][/[^\n]*\z/m].size]
    end

    def extract_str(str)
      quoted = str[/(?:[^"]*?(?<!\\)(?:\\\\)*)*"/]
      quoted ? quoted[0..-2] : str
    end

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
    def extract_keyword(keyword)
      case keyword
      when 'quote'  then :quote
      when 'lambda' then :lambda
      when 'cond'   then :cond
      when 'if'     then :if
      when 'atom'   then :atom
      when 'cons'   then :cons
      when 'eq'     then :eq
      when 'car'    then :car
      when 'cdr'    then :cdr
      when 'read'   then :read
      when 'write'  then :write
      when 'princ'  then :princ
      when '+'      then [:math_op, '+']
      when '-'      then [:math_op, '-']
      when '*'      then [:math_op, '*']
      when '/'      then [:math_op, '/']
      when '='      then [:math_op, '=']
      when '>'      then [:math_op, '>']
      when '<'      then [:math_op, '<']
      else [:token, keyword]
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity

    def parse_space(last_match)
      @pos += last_match[0].size
    end

    def parse_single_quote(elems)
      elems << Elem.new(code_pos, :quote)
      @pos += 1
    end

    def parse_double_quote(elems)
      elems << Elem.new(code_pos, :string_beg)
      @pos += 1
      str = extract_str(@src[@pos..])
      elems << Elem.new(code_pos, :string, str)
      @pos += str.size
      return if @src[@pos - str.size..] == str
      elems << Elem.new(code_pos, :string_end)
      @pos += 1
    end

    def parse_lparen(elems)
      elems << Elem.new(code_pos, :lparen)
      @pos += 1
    end

    def parse_rparen(elems)
      elems << Elem.new(code_pos, :rparen)
      @pos += 1
    end

    def parse_dot(elems)
      elems << Elem.new(code_pos, :dot)
      @pos += 1
    end

    def parse_float(elems, last_match)
      float = last_match[0].to_f
      elems << Elem.new(code_pos, :float, float)
      @pos += last_match[0].size
    end

    def parse_integer(elems, last_match)
      integer = last_match[0].to_i
      elems << Elem.new(code_pos, :integer, integer)
      @pos += last_match[0].size
    end

    def parse_nil(elems, last_match)
      elems << Elem.new(code_pos, :nil)
      @pos += last_match[0].size
    end

    def parse_t(elems, last_match)
      elems << Elem.new(code_pos, :t)
      @pos += last_match[0].size
    end

    def parse_keyword(elems, last_match)
      keyword = last_match[0]
      type, content = extract_keyword(keyword)
      elems << Elem.new(code_pos, type, content)
      @pos += keyword.size
    end
  end
end

