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

    def colorize(options = {})
      options = default_options.merge(options)
      unless [:background, :foreground].include?(options[:type])
        raise(ArgumentError, "Type must be a :background or :foreground")
      end
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

    def default_options
      { type: :foreground, bold: false, color: COLOR_NAMES[1] }
    end
  end
end
