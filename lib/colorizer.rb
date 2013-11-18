require 'matcher'
require 'colored_string'

module Prettys
  class Colorizer

    COLOR_NAMES = [
      :black, 
      :red, 
      :green, 
      :yellow, 
      :blue, 
      :magenta, 
      :cyan, 
      :white
    ]

    CHROMATIC_COLOR_NAMES = COLOR_NAMES[1...-1]

    COLORS = {}
    COLOR_NAMES.each_with_index do |color_name, index|
      COLORS[color_name] = index + 30
    end

    private_constant :COLOR_NAMES, :CHROMATIC_COLOR_NAMES, :COLORS

    def escape_sequence(options)
      options = default_options.merge(options)
      color_code = COLORS[options[:color]]
      color_code += 10 if options[:type] == :background
      "\e[#{color_code.to_s};#{(options[:bold] ? 1 : 2).to_s}m"
    end

    def end_of_escape_sequence
      "\e[0m"
    end

    def escaped_string(options)
      escape_sequence(options) + options[:string] + end_of_escape_sequence
    end

    def parse_complex_color_name(complex_color_name)
      return {
        color: complex_color_name,
        bold: false,
        type: :foreground
      } if COLOR_NAMES.include?(complex_color_name)

      splited_symbol = complex_color_name.to_s.split('_').map(&:to_sym)

      if splited_symbol.length == 1
        raise ArgumentError, 'Color name is not recognized.'
      elsif splited_symbol.length == 2
        prefix = splited_symbol[0]
        color = splited_symbol[1]
      else
        puts splited_symbol.inspect
        raise ArgumentError, 'Color name is too complex.'
      end

      if COLOR_NAMES.include?(color)
        if [:bold, :bright].include?(prefix)
          return {
            color: color,
            bold: true,
            type: :foreground
          }
        elsif [:bg, :background].include?(prefix)
          return {
            color: color,
            bold: false,
            type: :background
          }
        else
          raise ArgumentError, 'Color prefix is not recognized.'
        end
      else
        raise ArgumentError, 'Color name is not recognized.'
      end
    end

    def colorize(options = {})
      options = default_options.merge(options)
      unless [:background, :foreground].include?(options[:type])
        raise ArgumentError, 'Type must be a :background or :foreground.'
      end
      raw_string = options[:string].is_a?(ColoredString) ? options[:string].raw_string : options[:string]
      puts '=============================='
      puts raw_string.inspect
      marked_strings = Matcher.marked_strings(raw_string, options[:pattern])
      colored_string = ColoredString.new(marked_strings.map do |ms| 
        if ms[:marked]
          escaped_string({
            string: ms[:string],
            pattern: options[:pattern],
            type: options[:type],
            bold: options[:bold],
            color: options[:color]
          })
        else
          ms[:string]
        end
      end.join)
      if (options[:string].is_a?(ColoredString))
        puts colored_string.inspect
        colored_string.merge(options[:string])
      else
        colored_string
      end
    end

    private

    def default_options
      { type: :foreground, bold: false, color: COLOR_NAMES[1] }
    end
  end
end
