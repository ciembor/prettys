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
        result << { string: match[0], index: match.begin(0) - escape_sequences_length_sum }
        escape_sequences_length_sum += match[0].length
      end
      return result
    end

    def Matcher.marked_strings(string, pattern)
      matched =  string.scan(pattern).map { |s| { string: s, marked: true } }
      not_matched = string.split(pattern).map { |s| { string: s, marked: false } }
      result = if (string.match(pattern).begin(0))
        not_matched.zip(matched)
      else
        matched.zip(not_matched)
      end.flatten.compact
    end

  end
end
