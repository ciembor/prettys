require 'json'
require 'yaml'

module Prettys
  @format = :json

  class << self
    SUPPORTED_FORMATS = {
      raw: :inspect,
      json: :to_json, 
      yaml: :to_yaml
    }
    private_constant :SUPPORTED_FORMATS

    attr_reader :format

    def format=(format)
      raise ArgumentError, "Unsupported format." unless SUPPORTED_FORMATS.include?(format)
      @format = format
    end

    def prettys(object)
    end
  end
end

class Object
  def prettys 
    Prettys.prettys(self)
  end
end
