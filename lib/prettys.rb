require 'json'
require 'yaml'

module Prettys
  require 'converter'

  @converter = Converter.new(:json)

  class << self
    def format
      @converter.format
    end

    def format=(format)
      @converter.format = format
    end

    def prettys(object)
      @converter.convert(object)
    end
  end
end

class Object
  def prettys 
    Prettys.prettys(self)
  end
end
