require 'json'
require 'yaml'

module Prettys
  require 'converter'
  require 'colorizer'

  @converter = Converter.new(:json)
  @colorizer = Colorizer.new

  class << self
    def format
      @converter.format
    end

    def format=(format)
      @converter.format = format
    end

    def prettys(object, options)
      options[:string] = @converter.convert(object)
      @colorizer.colorize(options)
    end
  end
end

class Object
  def prettys(pattern, options = {})
    options[:pattern] = pattern
    Prettys.prettys(self, options)
  end
end
