require 'prettys'

describe 'Prettys' do

  describe '.prettys' do
    it { should respond_to(:prettys) }
  end

  describe 'Converter' do
    let(:converter) { Prettys::Converter.new(:json) }
    let(:object) { {'key' => "value", 'number' => 123, 'array' => ['el1', 'el2']} }

    it 'should have initializer accepting formats' do
      converter.format.should == :json
    end
    it 'should accept supported formats' do
      converter.format = :yaml
      converter.format.should == :yaml
    end
    it 'shouldn\'t accept not supported formats' do
      expect do
        converter.format = :not_supported_format 
      end.to raise_error(ArgumentError, 'Unsupported format.')
    end 
    it 'should parse to json' do
      converter.format = :json
      JSON.parse(converter.convert(object)).should == object
    end
    it 'should parse to yaml' do
      converter.format = :json
      YAML.load(converter.convert(object)).should == object
    end
    it 'should parse to raw' do
      converter.format = :raw
      eval(converter.convert(object)).should == object
    end
  end

  describe 'configuration' do
    it 'should have default format set to :json' do
      Prettys.format.should == :json
    end
    it 'should have setter' do
      Prettys.instance_variable_get(:@converter).should_receive(:format=).with(:yaml)
      Prettys.format = :yaml
    end
  end

  describe 'Colorizer' do
    let(:colorizer) { Prettys::Colorizer.new }

    describe '.colorize' do
      let(:some_string) { 'this is some string and this is awesome' }
      let(:string_pattern) { 'is' }

      it 'should add ANSI escape codes between matched strings' do
        colorizer.colorize({
          string: some_string, 
          pattern: string_pattern,
          type: :foreground,
          color: :blue,
          bold: true
        }).should == 'th\e44;0mis\e[0;0m \e44;0mis\e[0;0m some string and th\e44;0mis\e[0;0m \e44;0mis\e[0;0m awesome'
      end
      pending 'should add ANSI escape codes between matches of regular expression'
    end

    describe '.escape_sequence' do
      it 'should return correct escape code for the blue, bold text' do
        colorizer.escape_sequence({
          type: :foreground, 
          color: :blue,
          bold: true
        }).should == '\e44;0m'
      end
      it 'should return correct escape code for text on a red background' do
        colorizer.escape_sequence({
          type: :background, 
          color: :red,
          bold: false
        }).should == '\e31;1m'
      end
    end

    describe '.escaped_string' do
      it 'should return string with ansii escape sequences' do
        colorizer.escaped_string({
          string: 'RED_BOLD_STRING', 
          type: :foreground, 
          color: :blue,
          bold: true
        }).should == '\e44;0mRED_BOLD_STRING\e[0;0m'
      end
    end
  end

  describe 'Matcher' do
    let(:matcher) { Prettys::Matcher }
    let(:some_string) { 'this is some string and this is awesome' }
    let(:string_pattern) { 'is' }

    describe '.marked_strings' do
      it 'should return array of hashes with marked strings' do
        matcher::marked_strings(some_string, string_pattern).should == [
          { string: 'th', marked: false },
          { string: 'is', marked: true },
          { string: ' ', marked: false },
          { string: 'is', marked: true },
          { string: ' some string and th', marked: false },
          { string: 'is', marked: true },
          { string: ' ', marked: false },
          { string: 'is', marked: true },
          { string: ' awesome', marked: false }
        ]
      end
    end
  end
end

describe 'Object' do
  subject { Object.new }
  let(:pattern) { 'is' }

  describe '.prettys' do
    it 'should call Prettys.prettys' do
      Prettys.should_receive(:prettys).with(self, { pattern: pattern })
      prettys(pattern)
    end
  end
end
