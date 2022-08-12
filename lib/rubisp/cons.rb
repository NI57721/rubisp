# frozen_string_literal: true

module Rubisp
  class Cons
    attr_accessor :car, :cdr

    def initialize(car, cdr)
      @car = car
      @cdr = cdr
    end

    def to_s
      format('(%s . %s)', @car, @cdr)
    end

    def inspect
      format('#<Cons:%016x @car=%s, @cdr=%s>', object_id, @car, @cdr)
    end

    def ==(other)
      other.is_a?(Cons) ? car == other.car && cdr == other.cdr : false
    end

    alias eq ==
  end
end

