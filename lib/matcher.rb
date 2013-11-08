module Prettys
  module Matcher

    def Matcher.marked_strings(string, pattern)
      matched =  string.scan(pattern).map { |s| { string: s, marked: true } }
      not_matched = string.split(pattern).map { |s| { string: s, marked: false } }
      if (string.match(pattern).begin(0))
        not_matched.zip(matched)
      else
        matched.zip(not_matched)
      end.flatten.compact
    end

  end
end
