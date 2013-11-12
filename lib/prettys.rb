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

    def prettys(object, args)
      options = {}
      options[:string] = @converter.convert(object)
      args.each do |arg|
        if arg.is_a?(Regexp) || arg.is_a?(String)
          options[:string] = @colorizer.colorize(options.merge(pattern: arg))
        elsif arg.is_a?(Hash)
          arg.each do |complex_color_name, pattern|
            options_with_color = options.merge(
              @colorizer.parse_complex_color_name(complex_color_name)
            )
            if pattern.is_a?(Regexp) || pattern.is_a?(String)
              options[:string] = @colorizer.colorize(options_with_color.merge(pattern: pattern))
            elsif pattern.is_a?(Array)
              pattern.each do |single_pattern|
                options[:string] = @colorizer.colorize.options_with_color.merge(pattern: single_pattern)
              end
            else
              raise ArgumentError
            end
          end
        else 
          raise ArgumentError
        end
      end
      return options[:string]
    end

  end
end

class Object
  def prettys(*args)
    Prettys.prettys(self, args)
  end
end
