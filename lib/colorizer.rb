require 'matcher'

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

    TYPES = {
      foreground: 0,
      background: 1
    }

    private_constant :COLOR_NAMES, :CHROMATIC_COLOR_NAMES, :COLORS, :TYPES

    def escape_sequence(options)
      options = add_default_options(options)
      color_code = COLORS[options[:color]]
      color_code += 10 if options[:bold]
      "\\e#{color_code.to_s};#{TYPES[options[:type]].to_s}m"
    end

    def end_of_escape_sequence
      '\e[0;0m'
    end

    def escaped_string(options)
      escape_sequence(options) + options[:string] + end_of_escape_sequence
    end

    def colorize(options = {})
      options = add_default_options(options)
      marked_strings = Matcher.marked_strings(options[:string], options[:pattern])
      marked_strings.map do |ms| 
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
      end.join
    end

    private

    def add_default_options(options)
      options[:type] = :foreground unless options[:type]
      options[:bold] = false unless options[:bold]
      options[:color] = COLOR_NAMES[1] unless options[:color]
      return options
    end
  end
end
