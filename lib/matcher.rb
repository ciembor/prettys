module Prettys
  module Matcher

    def Matcher.without_escape_sequences(string)
      string.gsub(/(\e\[\d+;\d+m)|(\e\[0m)/, '')
    end

    def Matcher.escape_sequences_with_indexes(string)
      escape_sequences_length_sum = 0
      result = []
      string.enum_for(:scan, /(\e\[\d+;\d+m)|(\e\[0m)/).map do 

        match = Regexp.last_match
        result << {escape_sequence: match[0], index: match.begin(0) - escape_sequences_length_sum}
        escape_sequences_length_sum += result[:escape_sequence].length
      end
      return result
    end

    def Matcher.concatenated_escape_sequences_with_indexes(array1, array2)
      array1.concat(array2).sort_by { |escape_sequence| escape_sequence[:index] }.reverse
    end

    def Matcher.merge_escape_sequences(string1, string2)
      if without_escape_sequences(string1) != without_escape_sequences(string2)
        raise ArgumentError "These strings are different and cannot be merged."
      end
      result = without_escape_sequences(string1)
      concatenated_escape_sequences_with_indexes(string1, string2).each do |escape_sequence_with_indexes|
        result.insert(escape_sequence_with_index.index, escape_sequence_with_index.escape_sequence)
      end
      return result
    end

    def Matcher.marked_strings(string, pattern)
      original_string = without_escape_sequences(string)
      matched =  original_string.scan(pattern).map { |s| { string: s, marked: true } }
      not_matched = original_string.split(pattern).map { |s| { string: s, marked: false } }
      result = if (original_string.match(pattern).begin(0))
        not_matched.zip(matched)
      else
        matched.zip(not_matched)
      end.flatten.compact
      merge_escape_sequences(string, result)
    end

  end
end
