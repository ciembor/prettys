module Prettys
  class Converter
    attr_reader :format

    SUPPORTED_FORMATS = {
      raw: :inspect,
      json: :to_json, 
      yaml: :to_yaml
    }

    private_constant :SUPPORTED_FORMATS

    def initialize(format)
      self.format = format
    end

    def format=(format)
      raise ArgumentError, "Unsupported format." unless SUPPORTED_FORMATS.include?(format)
      @format = format
    end

    def convert(object)
      object.send(SUPPORTED_FORMATS[format])
    end
  end
end
