require 'matcher'

module Prettys
  class ColoredString

    attr_reader :raw_string, :escape_sequences

    def initialize(string)
      if string.is_a?(ColoredString)
        self.raw_string = string.raw_string
        self.escape_sequences = string.escape_sequences
      else
        self.raw_string = Matcher.without_escape_sequences(string)
        self.escape_sequences = Matcher.escape_sequences_with_indexes(string)
      end
    end

    def merge(colored_string)
      # raise ArgumentError 'Strings are not the same.' unless raw_string != colored_string.raw_string
      self.escape_sequences = escape_sequences.concat(colored_string.escape_sequences)
    end

    def to_s
      string = raw_string
      escape_sequences.each do |esc|
        string.insert(esc[:index], esc[:string])
      end
      return string
    end

    private 

    attr_writer :raw_string

    def escape_sequences=(sequences)
      @escape_sequences = sequences.sort_by do
       |esc| esc[:index]
      end.reverse
    end

  end
end