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
    describe '.colorize' do
      let(:colorizer) { Prettys::Colorizer.new }
      let(:some_string) { 'this is some string and this is awesome' }

      it 'should add ANSI escape codes between matched strings' do
      end
      pending 'should add ANSI escape codes between matches of regular expression'
    end
  end
end

describe 'Object' do
  subject { Object.new }
  describe '.prettys' do
    it 'should call Prettys.prettys' do
      Prettys.should_receive(:prettys).with(self)
      prettys
    end
  end
end