module Rinku
  VERSION = "2.0.4"

  class << self
    attr_accessor :skip_tags
  end

  self.skip_tags = nil
end

require 'rinku.so'
