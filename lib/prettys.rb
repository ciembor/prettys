require 'json'
require 'yaml'

module Prettys
  @format = :json

  class << self
    attr_accessor :format

    def prettys(object)
    end
  end
end

class Object
  def prettys 
    Prettys.prettys(self)
  end
end
